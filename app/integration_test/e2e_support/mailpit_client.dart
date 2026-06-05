import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'e2e_config.dart';

/// Thin HTTP client over the Mailpit REST API used by the e2e suite to read
/// invite links and reauthentication OTPs out of GoTrue's outbound mail.
///
/// Mailpit exposes a small, stable API at `/api/v1`. Only the endpoints the
/// suite needs are wrapped here. See https://mailpit.axllent.org/docs/api-v1/.
class MailpitClient {
  MailpitClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Removes every captured message. Call between tests that both send mail to
  /// the same address so the next `waitForLatestTo` call is unambiguous.
  Future<void> deleteAll() async {
    final response = await _client.delete(
      Uri.parse('${E2EConfig.mailpitUrl}/api/v1/messages'),
    );
    if (response.statusCode >= 300) {
      throw StateError(
        'Mailpit deleteAll failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Polls Mailpit until a message addressed to [recipient] arrives and
  /// returns its full body. Throws [TimeoutException] if nothing shows up
  /// within [E2EConfig.mailWaitTimeout].
  Future<MailpitMessage> waitForLatestTo(String recipient) async {
    final deadline = DateTime.now().add(E2EConfig.mailWaitTimeout);
    while (DateTime.now().isBefore(deadline)) {
      final id = await _latestIdFor(recipient);
      if (id != null) {
        return _fetch(id);
      }
      await Future<void>.delayed(E2EConfig.mailPollInterval);
    }
    throw TimeoutException('No mail for $recipient within timeout');
  }

  Future<String?> _latestIdFor(String recipient) async {
    final response = await _client.get(
      Uri.parse(
        '${E2EConfig.mailpitUrl}/api/v1/search'
        '?query=${Uri.encodeQueryComponent('to:$recipient')}',
      ),
    );
    if (response.statusCode != 200) {
      return null;
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final messages = (decoded['messages'] as List?) ?? const [];
    if (messages.isEmpty) {
      return null;
    }
    return (messages.first as Map<String, dynamic>)['ID'] as String;
  }

  Future<MailpitMessage> _fetch(String id) async {
    final response = await _client.get(
      Uri.parse('${E2EConfig.mailpitUrl}/api/v1/message/$id'),
    );
    if (response.statusCode != 200) {
      throw StateError(
        'Mailpit fetch failed: ${response.statusCode} ${response.body}',
      );
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return MailpitMessage(
      id: id,
      subject: decoded['Subject'] as String? ?? '',
      text: decoded['Text'] as String? ?? '',
      html: decoded['HTML'] as String? ?? '',
    );
  }

  void close() => _client.close();
}

/// Subset of the fields the e2e suite needs out of a Mailpit message.
class MailpitMessage {
  MailpitMessage({
    required this.id,
    required this.subject,
    required this.text,
    required this.html,
  });

  final String id;
  final String subject;
  final String text;
  final String html;

  /// Extracts the first GoTrue confirmation URL embedded in the message body.
  ///
  /// The self-host GoTrue templates render the action link as
  /// `${apiExternalUrl}/verify?token=...&type=invite&redirect_to=...`.
  /// Kong only routes `/auth/v1/verify`, so the consumer of this URL must
  /// rewrite the path before issuing a request.
  Uri get confirmationUrl {
    final pattern = RegExp(r'https?://[^\s"<>]+/(?:auth/v1/)?verify\?[^\s"<>]+');
    final match = pattern.firstMatch(html) ?? pattern.firstMatch(text);
    if (match == null) {
      throw StateError('No confirmation URL in message $id');
    }
    return Uri.parse(_decodeEntities(match.group(0)!));
  }

  /// Extracts the 6-digit reauthentication OTP from the message body.
  String get otpCode {
    final pattern = RegExp(r'(?<![0-9])([0-9]{6})(?![0-9])');
    final match = pattern.firstMatch(text) ?? pattern.firstMatch(html);
    if (match == null) {
      throw StateError('No 6-digit OTP in message $id');
    }
    return match.group(1)!;
  }

  String _decodeEntities(String input) =>
      input.replaceAll('&amp;', '&').replaceAll('&#x2F;', '/');
}
