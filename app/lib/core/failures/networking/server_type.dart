enum ServerType {
  supabase('supabase', 'Supabase'),
  syncServer('sync', 'Sync');

  const ServerType(this.key, this.name);

  final String key;
  final String name;
}
