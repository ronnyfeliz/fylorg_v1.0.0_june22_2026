// Modelo de runtime — NO se persiste directamente en Hive
class FileItem {
  final String path;
  final String name;
  final String extension;
  final int sizeBytes;
  final String category;
  final String? parentSubfolder;

  const FileItem({
    required this.path,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.category,
    this.parentSubfolder,
  });

  Map<String, dynamic> toMap() => {
        'path': path,
        'name': name,
        'extension': extension,
        'sizeBytes': sizeBytes,
        'category': category,
        'parentSubfolder': parentSubfolder,
      };

  factory FileItem.fromMap(Map<String, dynamic> map) => FileItem(
        path: map['path'] as String,
        name: map['name'] as String,
        extension: map['extension'] as String,
        sizeBytes: map['sizeBytes'] as int,
        category: map['category'] as String,
        parentSubfolder: map['parentSubfolder'] as String?,
      );
}
