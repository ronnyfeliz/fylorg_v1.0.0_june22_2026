import '../../data/models/organize_rule.dart';

List<OrganizeRule> defaultRules() => [
      OrganizeRule(
        categoryName: 'Imágenes',
        categoryKey: 'images',
        extensions: [
          '.jpg', '.jpeg', '.png', '.gif', '.ico',
          '.raw', '.webp', '.bmp', '.svg', '.tiff',
        ],
        order: 0,
      ),
      OrganizeRule(
        categoryName: 'Audio',
        categoryKey: 'audio',
        extensions: [
          '.mp3', '.wav', '.flac', '.ogg', '.m4a',
          '.aac', '.wma',
        ],
        order: 1,
      ),
      OrganizeRule(
        categoryName: 'Video',
        categoryKey: 'video',
        extensions: [
          '.mp4', '.mkv', '.avi', '.mov', '.wmv',
          '.flv', '.webm',
        ],
        order: 2,
      ),
      OrganizeRule(
        categoryName: 'Documentos',
        categoryKey: 'documents',
        extensions: [
          '.pdf', '.docx', '.doc', '.txt', '.xlsx',
          '.xls', '.pptx', '.ppt', '.odt', '.csv',
        ],
        order: 3,
      ),
      OrganizeRule(
        categoryName: 'Comprimidos',
        categoryKey: 'compressed',
        extensions: [
          '.zip', '.rar', '.7z', '.tar', '.gz',
        ],
        order: 4,
      ),
      OrganizeRule(
        categoryName: 'Código',
        categoryKey: 'code',
        extensions: [
          '.dart', '.js', '.py', '.java', '.cpp',
          '.c', '.html', '.css', '.json', '.xml',
        ],
        order: 5,
      ),
      OrganizeRule(
        categoryName: 'Otros',
        categoryKey: 'other',
        extensions: [],
        order: 6,
      ),
    ];
