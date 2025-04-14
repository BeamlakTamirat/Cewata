enum StoryType { fairyTale, riddle }

enum AgeGroup { children, allAges }

enum StoryCategory {
  animals,
  nature,
  culture,
  history,
  family,
  friendship,
  wisdom,
  userCreated
}

class Story {
  final String titleEn;
  final String titleAm;
  final String contentEn;
  final String contentAm;
  final StoryType type;
  final String topic;
  final String? answerEn;
  final String? answerAm;
  final DateTime dateCreated;
  final StoryCategory category;
  final bool isFeatured;
  bool hasBeenViewed;

  Story({
    required this.titleEn,
    required this.titleAm,
    required this.contentEn,
    required this.contentAm,
    required this.type,
    required this.topic,
    this.answerEn,
    this.answerAm,
    DateTime? dateCreated,
    this.category = StoryCategory.userCreated,
    this.isFeatured = false,
    this.hasBeenViewed = false,
  }) : dateCreated = dateCreated ?? DateTime.now();

  void markAsViewed() {
    hasBeenViewed = true;
  }

  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(dateCreated);
    return difference.inDays < 3 && !hasBeenViewed;
  }

  String getCategoryName() {
    switch (category) {
      case StoryCategory.animals:
        return 'Animals';
      case StoryCategory.nature:
        return 'Nature';
      case StoryCategory.culture:
        return 'Culture';
      case StoryCategory.history:
        return 'History';
      case StoryCategory.family:
        return 'Family';
      case StoryCategory.friendship:
        return 'Friendship';
      case StoryCategory.wisdom:
        return 'Wisdom';
      case StoryCategory.userCreated:
        return 'User Created';
    }
  }

  String getCategoryNameAmharic() {
    switch (category) {
      case StoryCategory.animals:
        return 'እንስሳት';
      case StoryCategory.nature:
        return 'ተፈጥሮ';
      case StoryCategory.culture:
        return 'ባህል';
      case StoryCategory.history:
        return 'ታሪክ';
      case StoryCategory.family:
        return 'ቤተሰብ';
      case StoryCategory.friendship:
        return 'ወዳጅነት';
      case StoryCategory.wisdom:
        return 'ጥበብ';
      case StoryCategory.userCreated:
        return 'የተጠቃሚ ፈጠራ';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'titleEn': titleEn,
      'titleAm': titleAm,
      'contentEn': contentEn,
      'contentAm': contentAm,
      'type': type.toString(),
      'topic': topic,
      'answerEn': answerEn,
      'answerAm': answerAm,
      'dateCreated': dateCreated.toIso8601String(),
      'category': category.toString(),
      'isFeatured': isFeatured,
      'hasBeenViewed': hasBeenViewed,
    };
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      titleEn: json['titleEn'],
      titleAm: json['titleAm'],
      contentEn: json['contentEn'],
      contentAm: json['contentAm'],
      type: _parseStoryType(json['type']),
      topic: json['topic'],
      answerEn: json['answerEn'],
      answerAm: json['answerAm'],
      dateCreated: DateTime.parse(json['dateCreated']),
      category: _parseStoryCategory(json['category']),
      isFeatured: json['isFeatured'] ?? false,
      hasBeenViewed: json['hasBeenViewed'] ?? false,
    );
  }

  static StoryType _parseStoryType(String type) {
    if (type.contains('fairyTale')) {
      return StoryType.fairyTale;
    } else {
      return StoryType.riddle;
    }
  }

  static StoryCategory _parseStoryCategory(String category) {
    for (var value in StoryCategory.values) {
      if (category.contains(value.toString())) {
        return value;
      }
    }
    return StoryCategory.userCreated;
  }
}
