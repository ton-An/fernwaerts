part of 'location_history_modal.dart';

class _LocationList extends StatelessWidget {
  const _LocationList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Location $index'),
        );
      },
    );
  }
}
