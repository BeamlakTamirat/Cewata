import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async'; // Add import for TimeoutException
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  final List<Story> _stories = [];
  bool _isLoading = false;
  String _error = '';
  bool _dataSavingMode = false;

  List<Story> get stories =>
      _stories..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get dataSavingMode => _dataSavingMode;

  set dataSavingMode(bool value) {
    _dataSavingMode = value;
    notifyListeners();
  }

  GenerativeModel? _model;

  StoryProvider() {
    _initializeGemini();
    _addPredefinedStories();
  }

  void _addPredefinedStories() {
    // Famous fairy tales - Animals category
    _stories.add(Story(
      titleEn: "The Tortoise and the Hare",
      titleAm: "ዓቧይና ጥንቸል",
      contentEn:
          "Once upon a time, a speedy hare boasted about how fast he could run. Tired of hearing him brag, the slow tortoise challenged him to a race. The hare quickly left the tortoise behind and, confident of winning, took a nap midway. When he awoke, he found that the tortoise, moving slowly but steadily, had already crossed the finish line. This tale teaches that persistence and determination often triumph over natural talent and overconfidence.",
      contentAm:
          "አንድ ጊዜ፣ ፈጣን ጥንቸል ስለፍጥነቱ ይኮራ ነበር። በትምክህቱ ደክሞት፣ ዝግተኛው ዓቧይ ወደ ሩጫ ፈታተነው። ጥንቸሉ በፍጥነት ዓቧዩን ጥሎ ሩቅ ሄደ፣ በማሸነፉ በመተማመን በመሃከል ለእንቅልፍ ተኛ። ሲነቃ፣ ዓቧዩ ዝግተኛ ሆኖ ነገር ግን በመጽናት እየተንቀሳቀሰ ጨረስ መስመሩን አልፎ አገኘው። ይህ ተረት የሚያስተምረው ጽናትና ቁርጠኝነት ብዙ ጊዜ ከተፈጥሮ ችሎታና ከራስ ግምት በላይ እንደሚያሸንፉ ነው።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 10)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Add the Hyena and Lion fairy tale
    _stories.add(Story(
      titleEn: "The Hungry Hyena and the Lion King",
      titleAm: "የተራበው ጅብና የአንበሶች ንጉሥ",
      contentEn:
          "A hungry hyena once schemed to steal food from the mighty lion king. \"Your Majesty,\" said the hyena with a bow, \"I've discovered a field full of fat gazelles just beyond your territory. I'm too small to catch them myself, but you could feast for days!\" The lion, flattered by the hyena's respect, followed him far from the pride. \"It's just over this hill,\" the hyena kept saying, leading the lion farther and farther until the lion was exhausted. When the lion collapsed from tiredness, the hyena snuck back to the pride and tried to steal the lions' fresh kill. But the lionesses had been watching and quickly chased the hyena away. When the lion king returned, he roared, \"Trust is earned, not given. And you, hyena, will never eat with lions again!\" The hyena skulked away, still hungry and now banned from the best hunting grounds. This tale teaches that deception might seem clever, but honesty builds lasting relationships.",
      contentAm:
          "አንድ ጊዜ የተራበ ጅብ ከኃይለኛው የአንበሶች ንጉሥ ምግብ ለመሰረቅ ዘዴ አሰበ። \"ጌታዬ፣\" አለ ጅቡ እየሰገደ፣ \"ከግዛትዎ ባሻገር በጣም የሰቡ የሚዳጋ ሎሌዎች ያሉበት ሜዳ አግኝቻለሁ። እኔ ለመያዝ በጣም ትንሽ ነኝ፣ ነገር ግን እርስዎ ለብዙ ቀናት መብላት ይችላሉ!\" አንበሳው፣ በጅቡ አክብሮት በመደሰት፣ ከወንድሞቹ ሩቅ ተከተለው። \"ከዚህ ኮረብታ ባሻገር ነው፣\" በማለት ጅቡ እየመራው የአንበሳውን ሃይል እስከሚዳክር ድረስ እያራቀው ወሰደው። አንበሳው በድካም ሲወድቅ፣ ጅቡ ወደ ቤተሰቦቹ ተመልሶ የአንበሶችን አዲስ ፍርስራሽ ለመሰረቅ ሞከረ። ግን እመበሎቹ እየተከታተሉ ነበርና ጅቡን በፍጥነት አባረሩት። የአንበሶች ንጉሥ ሲመለስ፣ \"እምነት የሚገኘው በመስራት እንጂ በመስጠት አይደለም። እና አንተ፣ ጅብ፣ ከአንበሶች ጋር ምግብ አትበላም!\" በማለት ጮኸ። ጅቡም፣ አሁንም ተርቦ እና ከሚሻለው የአደን ሥፍራ ተከልክሎ ተሸማቀቀ። ይህ ተረት የሚያስተምረው ማታለል አስተዋይ መስሎ ቢታይም እውነተኝነት ግን ሁልጊዜያዊ ግንኙነቶችን እንደሚገነባ ነው።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 5)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Add the Clever Goat and Lion fairy tale
    _stories.add(Story(
      titleEn: "The Clever Goat and the Foolish Lion",
      titleAm: "ብልህ ፍየልና ሞኝ አንበሳ",
      contentEn:
          "A hungry lion spotted a goat on a high, rocky ledge. \"Hello, friend goat!\" called the lion sweetly. \"Come down here where the grass is greener!\" The clever goat replied, \"Thank you for your concern, but I'm quite comfortable up here.\" \"But there's a wolf coming behind you!\" lied the lion. The goat smiled and said, \"How interesting! We don't have wolves in these mountains.\" Growing frustrated, the lion said, \"I've found a salt lick just down here!\" The goat laughed and replied, \"Dear lion, why are you so concerned with my dinner when you haven't had your own? If you're truly my friend, climb up and join me instead.\" The lion, unable to climb the steep rocks, left hungry and embarrassed. The goat called after him, \"Sometimes the best meal is the one you don't have to run from!\" This tale teaches that quick thinking can overcome brute strength, and it's wise to recognize deception.",
      contentAm:
          "አንድ የተራበ አንበሳ በከፍተኛ፣ ድንጋያማ ዳር ላይ ፍየል አየ። \"ሰላም፣ ጓደኛዬ ፍየል!\" ብሎ አንበሳው በጣፋጭ ተጣራ። \"ሣር አረንጓዴ ወደሆነበት እዚህ ውረድ!\" ብልሃተኛው ፍየል መለሰ፣ \"ስለጭንቀትህ አመሰግናለሁ፣ ግን እዚህ ላይ በጣም ምቹ ነኝ።\" \"ግን ከኋላህ ተኩላ እየመጣ ነው!\" ብሎ አንበሳው ዋሸ። ፍየሉ ሳቀና \"እንዴት አስደሳች ነገር ነው! በእነዚህ ተራሮች ላይ ተኩላዎች የሉንም\" አለ። እየተበሳጨ፣ አንበሳው \"እዚህ በታች ጨው አግኝቻለሁ!\" አለ። ፍየሉ ሳቀና መለሰ፣ \"ውድ አንበሳ፣ አንተ የራስህን ምግብ ሳትበላ ስለእኔ እራት ለምን እንደዚህ ትጨነቃለህ? እውነተኛ ጓደኛዬ ከሆንክ፣ እዚህ ወጥተህ ከእኔ ጋር ተቀላቀል።\" አንበሳው፣ ሹል ድንጋዮችን መውጣት ባለመቻሉ፣ ተርቦና ተሳፍሮ ሄደ። ፍየሉም \"አንዳንድ ጊዜ ምርጥ ምግብ ከእሱ መሮጥ የማያስፈልግህ ነው!\" ብሎ ጮኸበት። ይህ ተረት የሚያስተምረው ፈጣን አስተሳሰብ ጠንካራ ሃይልን ማሸነፍ እንደሚችል፣ እና ማታለልን መለየት ጥበብ መሆኑን ነው።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 7)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Add the Ape and Lion's Challenge fairy tale
    _stories.add(Story(
      titleEn: "The Ape's Challenge to the Lion",
      titleAm: "የዝንጀሮው ለአንበሳ የቀረበ ፈተና",
      contentEn:
          "The animals of the jungle held a contest to decide who was the most clever. The lion, as king, declared himself the judge. \"I will ask a question,\" he announced, \"and whoever answers correctly will win a week's supply of the finest fruits.\" All the animals gathered excitedly. \"What animal is the strongest and wisest in the jungle?\" asked the lion with a smug smile. The elephant trumpeted, \"You are, Your Majesty!\" The zebra bowed, \"The lion, of course!\" All the animals gave similar answers, except for the ape, who scratched his head thoughtfully. \"Well,\" said the ape, \"the strongest animal might be the elephant who can uproot trees. The wisest might be the owl who sees in darkness. The fastest is the cheetah who catches the swiftest prey.\" The lion growled, \"You did not answer my question!\" The ape replied calmly, \"I answered the true question of who has which quality. If you wanted praise instead of truth, perhaps that was not a fair contest question.\" The other animals gasped at the ape's boldness. The lion stared at the ape for a long moment, then surprised everyone by laughing. \"The ape wins the contest,\" declared the lion, \"for he alone had the courage to speak honestly to a king.\" From that day on, the lion consulted the ape on important jungle matters, and the animals learned that true wisdom includes both knowledge and courage.",
      contentAm:
          "የጫካው እንስሶች ማን እጅግ ብልህ እንደሆነ ለመወሰን ውድድር አዘጋጁ። አንበሳው፣ እንደ ንጉሥ፣ ራሱን ዳኛ አድርጎ ሾመ። \"አንድ ጥያቄ እጠይቃለሁ፣\" ብሎ አበሰረ፣ \"ትክክል የሚመልሰው ለአንድ ሳምንት የሚበቃ ምርጥ ፍራፍሬዎችን ያገኛል።\" እንስሶቹ ሁሉ በጉጉት ተሰበሰቡ። \"በዚህ ጫካ ውስጥ ምን አይነት እንስሳ ነው ጠንካራውና ብልሃተኛው?\" ብሎ አንበሳው በትዕቢት ሳቅ አለ። ዝሆኑ \"እርስዎ ነዎት፣ ጌታዬ!\" ሲል ጯሀ። ዔብራ ሰግዶ \"አንበሳው፣ በእርግጥ!\" አለ። ሁሉም እንስሶች ተመሳሳይ መልስ ሰጡ፣ ከዝንጀሮው በስተቀር፣ ራሱን በአስተዋይነት ያሻሻ ነበር። \"እንዲህ ነው፣\" አለ ዝንጀሮው፣ \"ጠንካራው እንስሳ ዛፎችን ሊነቅል የሚችለው ዝሆን ሊሆን ይችላል። ብልሃተኛው በጨለማ የሚያይ ቡፍ ሊሆን ይችላል። ፈጣኑ ደግሞ ፈጣን ሰለባን የሚይዘው ቀድዶ ነው።\" አንበሳው አገሰሰ፣ \"ጥያቄዬን አልመለስክም!\" ዝንጀሮው በሰከነ ሁኔታ መለሰ፣ \"ማን ምን ባህርይ እንዳለው ስለሚጠይቀው እውነተኛ ጥያቄ መልስ ሰጥቻለሁ። ከእውነት ይልቅ ሞገስን ከፈለግክ፣ ምናልባት ያ ፍትሃዊ የውድድር ጥያቄ አልነበረም።\" ሌሎቹ እንስሶች በዝንጀሮው ድፍረት ለቅሶ አቆሙ። አንበሳው ለረጅም ጊዜ ዝንጀሮውን ተመለከተው፣ ከዚያም ሁሉንም በማስገረም ሳቀ። \"ዝንጀሮው ውድድሩን አሸንፏል፣\" ብሎ አበሰረ አንበሳው፣ \"እሱ ብቻ ነው ለንጉሥ በእውነት ለመናገር ድፍረት የነበረው።\" ከዚያች ቀን ጀምሮ፣ አንበሳው ዝንጀሮውን በጫካ ጉዳዮች ላይ ይጠይቀው ነበር፣ እንስሶቹም እውነተኛ ጥበብ እውቀትንና ድፍረትን አንድ ላይ እንደሚይዝ ተማሩ።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 6)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Add the Fish Out of Water fairy tale
    _stories.add(Story(
      titleEn: "The Fish Who Wanted to Fly",
      titleAm: "መብረር የፈለገው ዓሣ",
      contentEn:
          "In a crystal-clear lake lived a small, brightly colored fish who watched birds soaring overhead every day. \"How wonderful it must be to fly!\" the fish would sigh. A friendly heron who often visited the lake noticed the sad fish. \"Why so glum?\" asked the heron. \"I wish I could fly like you,\" replied the fish. \"The water is so limiting.\" The heron tilted his head. \"But can you show me the underwater caves?\" The fish nodded. \"Can you sleep nestled in soft lake plants?\" Another nod. \"Can you dart through water faster than I can blink?\" The fish demonstrated proudly. The heron smiled. \"You see, I cannot do any of those things. Every time I catch a fish, I must return to land. I can only visit your world briefly.\" The fish thought about this. Later, a careless kingfisher scooped up the fish and accidentally dropped him on a lily pad. Gasping for breath, the fish realized how beautiful his water world was, and how perfectly suited he was for it. A friendly frog helped flip him back into the lake, where he swam happily, no longer envying the birds but appreciating his own special abilities. Sometimes we spend so much time wishing for what others have that we fail to appreciate our own unique gifts.",
      contentAm:
          "በጣም ንጹህ ሐይቅ ውስጥ አንድ ትንሽ፣ ቀለም የሞላው ዓሣ በየቀኑ ወፎች ከሰማይ በላይ ሲበሩ ይመለከት ነበር። \"እንዴት አስደናቂ ነገር ነው መብረር!\" ብሎ ዓሣው ይቆዝም ነበር። ሐይቁን በየጊዜው የሚጎበኝ ወዳጅ ሰጋን ኩሩሩ የተከፋውን ዓሣ አስተዋለ። \"ለምን እንደዚህ አዝነሃል?\" ብሎ ጠየቀ ሰጋን ኩሩሩ። \"እንደ አንተ መብረር እችል ዘንድ እመኝ ነበር፣\" ብሎ መለሰ ዓሣው። \"ውሃው በጣም ውስን ነው።\" ሰጋን ኩሩሩ ራሱን አዘነበለ። \"ግን የውሃ ውስጥ ዋሻዎችን ልታሳየኝ ትችላለህ?\" ዓሣው ጭንቅላቱን አነቀነቀ። \"በለሰላሳ የሐይቅ ተክሎች መካከል መተኛት ትችላለህ?\" ሌላ ነቀነቃ። \"ዓይኔን ከማያሟሙትበት ፍጥነት በላይ በውሃ ውስጥ መንሽራተት ትችላለህ?\" ዓሣው በኩራት አሳየው። ሰጋን ኩሩሩ ፈገግ አለ። \"እነዚህን ነገሮች አንዱንም ማድረግ እንደማልችል ታያለህ። ዓሣ በያዝኩ ቁጥር ወደ ምድር መመለስ አለብኝ። ዓለምህን በአጭር ጊዜ ብቻ ነው የምጎበኘው።\" ዓሣው ስለዚህ አሰበ። በኋላ፣ ጉዳት የሌለው ነባሪት ሰጋን ዓሣውን ቆልቶ በድንገት በዛንባቅ ላይ ጣለው። ለአየር እየተቸገረ ዓሣው የውሃ ዓለሙ እንዴት ውብ እንደሆነ፣ እና እሱም እንዴት ለዚያ ፍጹም ተስማሚ እንደሆነ ተገነዘበ። ጓደኛ እንቁራሪት ዓሣውን ወደ ሐይቁ እንዲመለስ በመገልበጥ ረዳው፣ እዚያም ጉዞውን በደስታ ዋኘ፣ ከዚያ በኋላ ወፎችን ሳይቀና ነገር ግን የራሱን ልዩ ችሎታዎች እያደነቀ። አንዳንድ ጊዜ ሌሎች ባላቸው ነገሮች ለመመኘት ብዙ ጊዜ እናጠፋለን የራሳችንን ልዩ ስጦታዎች ሳናደንቅ።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 4)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Lion and the Mouse",
      titleAm: "አንበሳና አይጥ",
      contentEn:
          "A mighty lion once caught a tiny mouse. As the lion was about to eat him, the mouse begged, \"Please spare me, and someday I'll help you.\" The lion laughed at the idea that such a small creature could ever help him but let the mouse go. Later, hunters trapped the lion in a net. The mouse, hearing the lion's roars, came and gnawed through the ropes, freeing him. \"You laughed when I said I would repay you,\" said the mouse. \"Now you see that even a little mouse can help a mighty lion.\" This teaches us that kindness is never wasted, and even the smallest friends can be valuable allies.",
      contentAm:
          "አንድ ጊዜ ኃይለኛ አንበሳ ትንሽ አይጥ ያዘ። አንበሳው ሊበላው ሲል፣ አይጡ \"እባክህ ተወኝ፣ አንድ ቀን እረዳሃለሁ\" ብሎ ለመነው። አንበሳው እንደዚህ ያለ ትንሽ ፍጡር ሊረዳው እንደሚችል ሲገረም ሳቀ ነገር ግን አይጡን ለቀቀው። በኋላ፣ አዳኞች አንበሳውን በረቀቀ መረብ ውስጥ ያዙት። አይጡም የአንበሳውን ጩኸት ሰምቶ መጣና ገመዶቹን ቆርጦ አንበሳውን ነፃ አወጣው። \"ልመልስልህ እችላለሁ ባልኩ ጊዜ ሳቅህብኝ፣\" አለው አይጡ። \"አሁን እንደምታይ ትንሽ አይጥም ቢሆን ኃይለኛውን አንበሳ ሊረዳው ይችላል።\" ይህ የሚያስተምረን ደግነትና የውስጥ ውበት ከጭካኔ በላይ እንደሚያሸንፍ ያሳያል።",
      type: StoryType.fairyTale,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 45)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Famous fairy tales - Culture category
    _stories.add(Story(
      titleEn: "Cinderella",
      titleAm: "ሲንደሬላ",
      contentEn:
          "Cinderella lived with her cruel stepmother and stepsisters who made her work as a servant. When the king held a ball, her fairy godmother appeared and transformed her rags into a beautiful gown and gave her glass slippers, turning a pumpkin into a carriage. At the ball, the prince fell in love with her, but at midnight everything returned to normal, and she fled, leaving behind one glass slipper. The prince searched the kingdom for the girl whose foot fit the slipper. When it fit Cinderella perfectly, he knew she was his true love. They married and lived happily ever after, showing that kindness and inner beauty triumph over cruelty.",
      contentAm:
          "ሲንደሬላ ከጨካኝ እንጀራ እናቷና እህቶቿ ጋር ትኖር ነበር፤ እነሱም እንደ አገልጋይ እንድትሰራ አደረጓት። ንጉሱ ሲያደርግ በዓል ላይ፣ የዕድል እናቷ ተገለጠችና ጨርቆችዋን ወደ ውብ ቀሚስ ቀየረች እንዲሁም የብርጭቆ ጫማዎችን ሰጠቻት፣ ዱባን ወደ ረዥም ተሽከርካሪ ቀይራ። በዓሉ ላይ፣ ልዑል ተወላት፣ ነገር ግን በእኩለ ሌሊት ሁሉም ነገር ወደ ነበረበት ተመለሰ፣ ስለዚህ እሷም አንድ የብርጭቆ ጫማ ትታ ኮበለለች። ልዑሉም ጫማው የሚስማማት ልጃገረድ ለማግኘት መንግስቱን ሁሉ ፈለገ። ጫማው ሲንደሬላን በትክክል ሲስማማት፣ እሷ እውነተኛ ፍቅሩ እንደሆነች ተገነዘበ። ተጋቡና በደስታ ኖሩ፣ ይህም ደግነትና የውስጥ ውበት ከጭካኔ በላይ እንደሚያሸንፍ ያሳያል።",
      type: StoryType.fairyTale,
      topic: "Magic",
      dateCreated: DateTime.now().subtract(const Duration(days: 25)),
      category: StoryCategory.culture,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "Beauty and the Beast",
      titleAm: "ውበትና አውሬው",
      contentEn:
          "A merchant picked a rose for his daughter Beauty from a beast's garden. The angry beast demanded the merchant's life in return, but allowed him to go home to say goodbye. Beauty insisted on taking her father's place. At the beast's castle, she discovered he was kind despite his appearance. Every night, the beast asked Beauty to marry him, and she refused. When Beauty learned her father was ill, the beast let her visit him. After staying longer than promised, she returned to find the beast dying of a broken heart. Her tears of love fell on him, breaking the spell, and he transformed into a handsome prince. They lived happily ever after, showing that true beauty lies within.",
      contentAm:
          "አንድ ነጋዴ ለልጁ ውበት ከአውሬው ጓሮ ውስጥ አበባ ቆረጠ። የተናደደው አውሬ በመቀጣት ነጋዴውን ሕይወት እንዲያጣ ጠየቀ, ነገር ግን ወደ ቤት ሄዶ ለመሰናበት ፈቀደለት። ውበት የአባቷን ቦታ ለመውሰድ አስቀድማ አስጠየቀች። በአውሬው ግንብ ውስጥ ሆና፣ ከመልኩ ባሻገር ደግ እንደሆነ ተመለከተች። በየምሽቱ አውሬው ውበትን እንድታገባው ይጠይቃት ነበር፣ እሷም ትከለክለው ነበር። ውበት አባቷ ታሞ እንደሆነ ስትረዳ፣ አውሬው ሄዳ እንድትጠይቀው ፈቀደላት። ከቃሏ በላይ ከቆየች በኋላ፣ ተመልሳ አውሬውን ልቡ ተሰብሮ ሲሞት አገኘችው። የፍቅሯ እንባዎች በእሱ ላይ ወድቀው፣ ድግምት ሰባሩ፣ አውሬውም ወደ ውብ ልዑል ተቀየረ። ለዘላለም በደስታ ኖሩ፣ ይህም እውነተኛ ውበት በውስጡ እንደሚገኝ ያሳያል።",
      type: StoryType.fairyTale,
      topic: "Magic",
      dateCreated: DateTime.now().subtract(const Duration(days: 30)),
      category: StoryCategory.culture,
      hasBeenViewed: false,
    ));

    // Famous fairy tales - Nature category
    _stories.add(Story(
      titleEn: "Jack and the Beanstalk",
      titleAm: "ጃክና የባቄላ ዛፍ",
      contentEn:
          "Jack traded his cow for magic beans, which his mother angrily threw outside. Overnight, the beans grew into a giant beanstalk reaching the clouds. Jack climbed it and found a castle inhabited by a giant. While the giant slept, Jack stole a bag of gold coins. On later visits, he took a goose that laid golden eggs and a magical singing harp. The angry giant chased Jack down the beanstalk, but Jack cut it down, causing the giant to fall to his death. Jack and his mother lived comfortably with their newfound wealth. This tale teaches about taking risks, seizing opportunities, and sometimes, the need to face one's fears.",
      contentAm:
          "ጃክ ላሟን በድንቅ ባቄላዎች ለወጠ፣ እናቱም በንዴት ወደ ውጭ ጣለቻቸው። በሌሊቱ፣ ባቄላዎቹ ወደ ደመናዎች ድረስ የሚደርስ ግዙፍ ዛፍ ሆነው አደጉ። ጃክ ወጥቶ በደመናዎች ላይ ያለ ግንብ አገኘ፤ በዚህም አንድ ዘላን ይኖር ነበር። ዘላኑ እንቅልፍ ላይ እያለ፣ ጃክ ከረጢት የሙሉ የወርቅ ሳንቲሞችን ሰረቀ። በሌላ ጊዜም፣ የወርቅ እንቁላል የምታጠምድ ዝይ እና ድንቅ የሙዚቃ መሳሪያ ሃርፕ ወሰደ። የተቆጣው ዘላን ጃክን በዛፉ ላይ አሳደደው፣ ነገር ግን ጃክ ዛፉን ቆረጠው፣ ዘላኑም ወድቆ ሞተ። ጃክና እናቱ በአዲስ ሃብታቸው በምቾት ኖሩ። ይህ ተረት ስለ ስጋቶች መውሰድ፣ አጋጣሚዎችን መጠቀም እና አንዳንድ ጊዜ ፍርሃቶቻችንን መጋፈጥ እንዳለብን ነው።",
      type: StoryType.fairyTale,
      topic: "Magic",
      dateCreated: DateTime.now().subtract(const Duration(days: 15)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "Hansel and Gretel",
      titleAm: "ሃንሴልና ግሬቴል",
      contentEn:
          "During a famine, a woodcutter's wife convinced him to abandon his children, Hansel and Gretel, in the forest. Overhearing this plan, Hansel collected pebbles and left a trail to follow home. When abandoned again, they used breadcrumbs, but birds ate them. Lost in the forest, they found a house made of gingerbread and sweets. An old witch lived there who trapped children to eat them. She imprisoned Hansel, planning to fatten him up, while Gretel worked as a servant. When the witch prepared the oven to cook Hansel, clever Gretel pushed her into it instead. The children found the witch's treasure, followed a white bird home, and reunited with their remorseful father. Their stepmother had died, and they lived happily together, having learned to rely on their wits and each other to overcome evil.",
      contentAm:
          "በአንድ ረሃብ ወቅት፣ የአንድ እንጨት ቆራጭ ሚስት ልጆቻቸውን ሃንሴልና ግሬቴልን በጫካ ውስጥ እንዲተዉ አሳመነችው። ይህንን እቅድ ሲሰሙ፣ ሃንሴል ጠጠሮችን ሰብስቦ ወደ ቤት መንገድ አስቀመጠ። ሁለተኛ ሲተዉዋቸው፣ የዳቦ ፍርፋሪዎችን ተጠቀሙ፣ ነገር ግን ወፎች በሉዋቸው። በጫካው ውስጥ ጠፍተው፣ የዳቦና ጣፋጭ ነገሮች የተሰራ ቤት አገኙ። አንድ አሮጊት አስማተኛ ልጆችን ለመብላት የምታጠምድ ትኖር ነበር፣ ሃንሴልን አስራ በማስወፈር ግሬቴልን እንደ አገልጋይ አሰራች። አስማተኛዋ ሃንሴልን ለመጋገር ምድጃ ስታዘጋጅ፣ ብልህዋ ግሬቴል ወደ ምድጃው እሷን ገፋች። ልጆቹም የአስማተኛዋን ሀብት አግኝተው፣ አንድ ነጭ ወፍን ተከትለው ወደ ቤት ደረሱ፣ ከተጸጸተው አባታቸው ጋርም ተዋሃዱ። እንጀራ እናታቸው ምትታ ነበር፣ እነሱም ጭራቅን ለማሸነፍ ብልሃትና አንድ ላይ መተጋገዝ እንዳለባቸው ተምረው በደስታ አብረው ኖሩ።",
      type: StoryType.fairyTale,
      topic: "Survival",
      dateCreated: DateTime.now().subtract(const Duration(days: 12)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    // Famous fairy tales - History category
    _stories.add(Story(
      titleEn: "The Emperor's New Clothes",
      titleAm: "የንጉሱ አዲስ ልብሶች",
      contentEn:
          "A vain emperor hired two swindlers who claimed they could weave the most magnificent clothes. These clothes, they said, were invisible to anyone who was stupid or unfit for their position. As the swindlers pretended to weave, officials and the emperor himself pretended to see the clothes, fearing they would appear incompetent. When the emperor paraded through the town in his \"new clothes,\" all the townspeople played along, except for one child who cried out, \"But he has nothing on!\" This tale teaches about the dangers of pride, peer pressure, and the importance of speaking the truth even when everyone else is silent.",
      contentAm:
          "አንድ ትምክህተኛ ንጉስ ሁለት ተንኮለኞችን ቀጠረ፣ እነሱም በጣም ድንቅ ልብሶችን መስራት እንደሚችሉ ተናገሩ። እነዚህ ልብሶች፣ እንዳሉት፣ ለሚናቸው ብቁ ላልሆኑ ወይም ሞኝ ለሆኑ ሰዎች የማይታዩ ነበሩ። ተንኮለኞቹ ልብሶችን እየሰሩ ሲመስሉ፣ ባለሥልጣናቱና ንጉሱ እራሱ ብቁ እንዳልሆኑ እንዳይታይ ፈርተው ልብሶቹን እንደሚያዩ ገለጹ። ንጉሱ ከተማውን በ\"አዲስ ልብሶቹ\" ሲዞር፣ የከተማው ሰዎች ሁሉ ተስማሙ፣ ሆኖም ግን አንድ ልጅ \"ምንም አልለበሰም!\" ብሎ ጮኸ። ይህ ተረት ስለ ኩራት፣ የአቻ ግፊት አደጋዎች፣ እና ሌሎች ሁሉ ዝምታን ሲመርጡ ሳይቀር እውነቱን ስለመናገር ጠቀሜታ ያስተምራል።",
      type: StoryType.fairyTale,
      topic: "Truth",
      dateCreated: DateTime.now().subtract(const Duration(days: 20)),
      category: StoryCategory.history,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Pied Piper of Hamelin",
      titleAm: "የሓሜሊን እንቁራሪት",
      contentEn:
          "The town of Hamelin was infested with rats. A stranger, dressed in colorful clothes, offered to rid the town of rats for a fee, which the mayor promised to pay. The piper played his pipe, leading all the rats to the river where they drowned. When the mayor refused to pay the agreed amount, the piper sought revenge. He played a different tune and led all the children of Hamelin away, never to return. This tale serves as a warning about the consequences of breaking promises and the importance of honoring one's word.",
      contentAm:
          "የሃሜሊን ከተማ በአይጦች ተጥለቅልቋል። አንድ በቀለም ልብሶች የተደራጀ መጻተኛ፣ ከከተማው አይጦችን ለማጥፋት በክፍያ ሃላፊነት ወሰደ፣ ከንቲባውም ለመክፈል ቃል ገባ። እንቁራሪቱ ዋሽንትዋን ነፋ፣ ሁሉንም አይጦች ወደ ወንዝ አመራ ወዲያም ሰጠሙ። ከንቲባው የተስማሙትን መጠን ለመክፈል ባለመፈለጉ፣ እንቁራሪቱ በቀል ፈለገ። የተለየ ዜማ ነፍቶ የሃሜሊንን ልጆች ሁሉ ወደማይመለሱበት ቦታ ወሰዳቸው። ይህ ተረት ቃል ስለመግባትና መፈጸም አስፈላጊነት ተተካ ያሳያል።",
      type: StoryType.fairyTale,
      topic: "Promises",
      dateCreated: DateTime.now().subtract(const Duration(days: 35)),
      category: StoryCategory.history,
      hasBeenViewed: false,
    ));

    // Wisdom riddles
    _stories.add(Story(
      titleEn: "The One Who Sees All",
      titleAm: "ሁሉን የሚያይ",
      contentEn:
          "I rise over mountains and shine upon valleys. Kings and beggars alike see me. I disappear each night but return without fail. What am I?",
      contentAm:
          "በተራሮች ላይ እወጣለሁ በሸለቆዎች ላይም አበራለሁ። ነገስታትም፣ ሆኑ ለማኞች እኔን ያዩኛል። በየሌሊቱ እጠፋለሁ ግን ያለምንም ጉድለት እመለሳለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "The Sun",
      answerAm: "ፀሐይ",
      dateCreated: DateTime.now().subtract(const Duration(days: 15)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Silent Traveler",
      titleAm: "ዝም ያለው ተጓዥ",
      contentEn:
          "I travel around the world but never leave my corner. What am I?",
      contentAm: "በዓለም ዙሪያ እጓዛለሁ ግን ማዕዘኔን አልለቅም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A postage stamp",
      answerAm: "የፖስታ ቴምብር",
      dateCreated: DateTime.now().subtract(const Duration(days: 25)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Endless Meal",
      titleAm: "የማያልቅ ምግብ",
      contentEn: "The more you take, the more you leave behind. What am I?",
      contentAm: "ብዙ የወሰድክ ቁጥር፣ ብዙ ትተሃል። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "Footsteps",
      answerAm: "የእግር ሽለላ",
      dateCreated: DateTime.now().subtract(const Duration(days: 8)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Talking Hole",
      titleAm: "የሚያወራ ቀዳዳ",
      contentEn:
          "I speak without a mouth and hear without ears. I have no body, but come alive with wind. What am I?",
      contentAm:
          "ያለ አፍ እናገራለሁ ያለ ጆሮም እሰማለሁ። ሰውነት የለኝም፤ ነገር ግን በነፋስ ሕይወት እገኛለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "An echo",
      answerAm: "ድምፅ መመለስ",
      dateCreated: DateTime.now().subtract(const Duration(days: 18)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Never Tired Brother",
      titleAm: "የማይደክም ወንድም",
      contentEn: "What goes up but never comes down?",
      contentAm: "ወደላይ የሚሄድ ነገር ግን ወደታች የማይመለስ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "Your age",
      answerAm: "እድሜህ",
      dateCreated: DateTime.now().subtract(const Duration(days: 2)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    // Funny riddles
    _stories.add(Story(
      titleEn: "The Impatient Father",
      titleAm: "ትዕግስተኛ ያልሆነ አባት",
      contentEn: "What has many keys but can't open a single lock?",
      contentAm: "ብዙ ቁልፎች ያሉት ነገር ግን አንድም መቆለፊያ መክፈት የማይችል?",
      type: StoryType.riddle,
      topic: "Humor",
      answerEn: "A piano",
      answerAm: "ፒያኖ",
      dateCreated: DateTime.now().subtract(const Duration(days: 1)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Lazy Worker",
      titleAm: "ሰነፈ ሰራተኛ",
      contentEn: "What gets wetter as it dries?",
      contentAm: "በሚያደርቅ ቁጥር የሚረጥብ ነገር?",
      type: StoryType.riddle,
      topic: "Humor",
      answerEn: "A towel",
      answerAm: "ፎጣ",
      dateCreated: DateTime.now().subtract(const Duration(hours: 12)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    // Add a few fresh user-created examples for the NEW badge to work
    _stories.add(Story(
      titleEn: "Mountains of Wisdom",
      titleAm: "የጥበብ ተራሮች",
      contentEn:
          "The old man who lived in the mountains taught every visitor a single lesson. He said, \"Age is like climbing a mountain. You might grow tired, but the view gets better.\" This simple wisdom spread throughout the village below, changing how people viewed their elders.",
      contentAm:
          "በተራሮች ላይ የሚኖረው አዛውንት ለእያንዳንዱ ሰው አንድ ትምህርት ያስተምራል። \"እድሜ እንደ ተራራ መውጣት ነው። ልትደክም ትችላለህ፣ ነገር ግን እይታው እየተሻለ ይሄዳል\" ይላል። ይህ ቀላል ጥበብ በታች በሚገኘው መንደር ዙሪያ ተሰራጭቶ ሰዎች ለአዛውንቶቻቸው ያላቸውን አመለካከት ቀየረ።",
      type: StoryType.fairyTale,
      topic: "Wisdom",
      dateCreated: DateTime.now().subtract(const Duration(hours: 2)),
      category: StoryCategory.wisdom,
    ));

    _stories.add(Story(
      titleEn: "The Falling Rain",
      titleAm: "የሚወርደው ዝናብ",
      contentEn: "I fall but never get hurt. What am I?",
      contentAm: "እወድቃለሁ ግን ፈፅሞ አልጎዳም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      answerEn: "Rain",
      answerAm: "ዝናብ",
      dateCreated: DateTime.now().subtract(const Duration(minutes: 30)),
      category: StoryCategory.nature,
    ));

    // Add more wisdom riddles
    _stories.add(Story(
      titleEn: "The Broken Promise",
      titleAm: "የተሰበረው ቃል",
      contentEn:
          "The more you take of me, the more you leave behind. What am I?",
      contentAm: "ከእኔ ብዙ ስትወስድ፣ ብዙ ትተሃል። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "Footsteps",
      answerAm: "የእግር ሽለላ",
      dateCreated: DateTime.now().subtract(const Duration(days: 8)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Invisible Consumer",
      titleAm: "የማይታየው ፈጣሪ",
      contentEn:
          "I devour all - trees, beasts, flowers, birds, fish, mountains, and seas. I gnaw iron and bite steel. I turn stone to dust. What am I?",
      contentAm:
          "ሁሉንም እበላለሁ - ዛፎችን፣ አውሬዎችን፣ አበቦችን፣ ወፎችን፣ ዓሦችን፣ ተራሮችን እና ባህሮችን። ብረትን እቆረጥማለሁ፣ ቻካን እነክሳለሁ። ድንጋይን አመድ አደርጋለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "Time",
      answerAm: "ጊዜ",
      dateCreated: DateTime.now().subtract(const Duration(days: 7)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Weightless Burden",
      titleAm: "ያለክብደት ጫና",
      contentEn:
          "I am light as a feather, but the strongest person cannot hold me for more than a few minutes. What am I?",
      contentAm:
          "እንደ ላባ ቀላል ነኝ፣ ነገር ግን ብርቱው ሰው እንኳ ከጥቂት ደቂቃዎች በላይ ሊይዘኝ አይችልም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "Breath",
      answerAm: "እስትንፋስ",
      dateCreated: DateTime.now().subtract(const Duration(days: 6)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Blind Prophet",
      titleAm: "ዓይነ ስውር ነቢይ",
      contentEn:
          "I can predict the future but cannot speak. I show what will come but only those wise enough understand my message. What am I?",
      contentAm:
          "መጪውን መተንበይ እችላለሁ ግን መናገር አልችልም። የሚመጣውን አሳያለሁ ግን ብልህ የሆኑ ብቻ ናቸው መልእክቴን የሚረዱት። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A dream",
      answerAm: "ሕልም",
      dateCreated: DateTime.now().subtract(const Duration(days: 5)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Honest Thief",
      titleAm: "ታማኝ ሌባ",
      contentEn:
          "I steal your face and never return it, yet you never report me to authorities. What am I?",
      contentAm:
          "ፊትህን እሰርቃለሁ ግን ፈጽሞ አልመልስም፣ ሆኖም ግን ለባለስልጣናት አታመለክተኝም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A mirror",
      answerAm: "መስታወት",
      dateCreated: DateTime.now().subtract(const Duration(days: 4)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Endless Meal",
      titleAm: "የማያልቅ ምግብ",
      contentEn: "I'm full of holes but still hold water. What am I?",
      contentAm: "በቀዳዳዎች የተሞላሁ ነኝ ግን አሁንም ውሃ እይዛለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A sponge",
      answerAm: "ስፖንጅ",
      dateCreated: DateTime.now().subtract(const Duration(days: 3)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Invisible Bridge",
      titleAm: "የማይታየው ድልድይ",
      contentEn: "I connect two people but touch only one. What am I?",
      contentAm: "ሁለት ሰዎችን አገናኛለሁ ግን አንዱን ብቻ እነካለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A telephone",
      answerAm: "ስልክ",
      dateCreated: DateTime.now().subtract(const Duration(days: 2)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Friendly Giant",
      titleAm: "ወዳጅ ዘላን",
      contentEn: "I'm tall when I'm young, and short when I'm old. What am I?",
      contentAm: "ወጣት ሳለሁ ረጅም ነኝ፣ ሽማግሌ ሳለሁ ደግሞ አጭር ነኝ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A candle",
      answerAm: "ሻማ",
      dateCreated: DateTime.now().subtract(const Duration(days: 1)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Patient Warrior",
      titleAm: "ታጋሽ ጀግና",
      contentEn:
          "I fly without wings. I cry without eyes. Wherever I go, darkness follows me. What am I?",
      contentAm:
          "ያለ ክንፍ እበራለሁ። ያለ አይን እለቅሳለሁ። የትም ብሄድ፣ ጨለማ ይከተለኛል። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A cloud",
      answerAm: "ደመና",
      dateCreated: DateTime.now().subtract(const Duration(days: 1)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Silent Traveler",
      titleAm: "ዝም ያለው ተጓዥ",
      contentEn:
          "I travel around the world but never leave my corner. What am I?",
      contentAm: "በዓለም ዙሪያ እጓዛለሁ ግን ማዕዘኔን አልለቅም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "A postage stamp",
      answerAm: "የፖስታ ቴምብር",
      dateCreated: DateTime.now().subtract(const Duration(days: 25)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The One Who Sees All",
      titleAm: "ሁሉን የሚያይ",
      contentEn:
          "I rise over mountains and shine upon valleys. Kings and beggars alike see me. I disappear each night but return without fail. What am I?",
      contentAm:
          "በተራሮች ላይ እወጣለሁ በሸለቆዎች ላይም አበራለሁ። ነገስታትም፣ ሆኑ ለማኞች እኔን ያዩኛል። በየሌሊቱ እጠፋለሁ ግን ያለምንም ጉድለት እመለሳለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Wisdom",
      answerEn: "The Sun",
      answerAm: "ፀሐይ",
      dateCreated: DateTime.now().subtract(const Duration(days: 15)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    // Add animal-themed riddles
    _stories.add(Story(
      titleEn: "The Laughing Hyena",
      titleAm: "ሳቂ ጅብ",
      contentEn:
          "I laugh but I'm not happy. I sound like I'm having fun but I might be hunting. I live in Africa and look like a wild dog. What am I?",
      contentAm:
          "እስቃለሁ ግን ደስተኛ አይደለሁም። እየተዝናናሁ እንደሆነ ይሰማል ግን ምናልባት እየአደንኩ ነው። በአፍሪካ እኖራለሁ፣ እንደ ጫካ ውሻም እመስላለሁ። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      answerEn: "A hyena",
      answerAm: "ጅብ",
      dateCreated: DateTime.now().subtract(const Duration(days: 3)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Proud King",
      titleAm: "ኩሩ ንጉሥ",
      contentEn:
          "I have a mane but I'm not a horse. I roar but I'm not a car. I have paws but I'm not a bear. I'm known as the king but I have no crown. What am I?",
      contentAm:
          "ፀጉረ አንገት አለኝ ግን ፈረስ አይደለሁም። አገሳለሁ ግን መኪና አይደለሁም። ጭራዎች አሉኝ ግን ድብ አይደለሁም። እንደ ንጉሥ ታዋቂ ነኝ ግን ዘውድ የለኝም። እኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      answerEn: "A lion",
      answerAm: "አንበሳ",
      dateCreated: DateTime.now().subtract(const Duration(days: 2)),
      category: StoryCategory.wisdom,
      hasBeenViewed: false,
    ));

    // Famous fairy tales from family category
    _stories.add(Story(
      titleEn: "The Three Little Pigs",
      titleAm: "ሦስቱ ትናንሽ አሳማዎች",
      contentEn:
          "Three little pigs left home to build their own houses. The first pig built a house of straw, the second a house of sticks, and the third a house of bricks. When a hungry wolf came, he blew down the straw house and the stick house easily, but the brick house was too strong. The wolf tried to enter through the chimney, but fell into a pot of boiling water the clever third pig had prepared. The wolf ran away, and the three pigs lived together in the brick house, learning that hard work and proper planning brings safety and security to a family.",
      contentAm:
          "ሦስት ትናንሽ አሳማዎች የራሳቸውን ቤት ለመሥራት ቤታቸውን ለቀው ሄዱ። የመጀመሪያው አሳማ የገለባ ቤት፣ ሁለተኛው የእንጨት ቤት፣ ሦስተኛው ደግሞ የጡብ ቤት ሠራ። አንድ የተራበ ተኩላ ሲመጣ፣ የገለባውን ቤትና የእንጨቱን ቤት በቀላሉ አፍርሶ ጣላቸው፣ ነገር ግን የጡቡ ቤት በጣም ጠንካራ ነበር። ተኩላው በማቀጣጠያው በኩል ለመግባት ሞከረ፣ ነገር ግን ብልህ ሦስተኛው አሳማ ባዘጋጀው የፈላ ውሃ ድስት ውስጥ ወደቀ። ተኩላው ሮጦ ሄደ፣ ሦስቱም አሳማዎች በጡብ ቤት ውስጥ አብረው ኖሩ፣ ይህም ጠንክሮ መሥራትና ትክክለኛ እቅድ ለቤተሰብ ደህንነትና ዋስትና እንደሚያመጣ ተማሩ።",
      type: StoryType.fairyTale,
      topic: "Family",
      dateCreated: DateTime.now().subtract(const Duration(days: 40)),
      category: StoryCategory.family,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Grandmother's Treasure",
      titleAm: "የአያት ሴት ሀብት",
      contentEn:
          "In a small village, a grandmother lived with her three grandchildren. Though poor, she told them they had a precious family treasure. The children spent years searching the small house for hidden gold or jewels but found nothing. When the grandmother became ill, she called them close and said, \"The time has come to reveal our treasure.\" She handed them a simple wooden box containing three items: a needle, a worn book, and a small pouch of seeds. \"These represent our family's true wealth,\" she explained. \"The needle symbolizes self-reliance - with it, I've clothed our family for generations. The book holds our family stories and wisdom. The seeds represent our connection to the land and our ability to grow and nurture life.\" The grandchildren finally understood that the greatest family treasures weren't gold or gems, but the values, skills, and stories passed down through generations. After their grandmother's passing, they honored her by continuing these traditions and teaching them to their own children, ensuring the family's true treasure would never be lost.",
      contentAm:
          "በአንድ ትንሽ መንደር፣ አንዲት አያት ሴት በሰፊ ያጣመረችው ብርድ ልብስ ላይ አንድ ካሬ ታክል ነበር። እያንዳንዱ የጨርቅ ቁራጭ ታሪክ ነበረው - ከወንድ ልጅዋ የሠርግ ልብስ ላይ የተቆረጠ፣ ከሴት ልጅዋ የመጀመሪያ የትምህርት ቤት ልብስ ላይ የተቆረጠ ቁራጭ፣ ያረጀው የባሏ ተወዳጅ ሸሚዝ። ብርድ ልብሱ ለአሥርት ዓመታት አደገ፣ በውበቱና በመጠኑም በመንደራቸው ዝናን አትረፈ። አያት ሴትዋ ከሞተች በኋላ፣ አምስቱ ልጆቿ ውድ ብርድ ልብሱን ማን ሊወርስ እንደሚገባው ተጨቃጨቁ። መስማማት ባለመቻላቸው፣ ወደ አምስት እኩል ክፍሎች ለመቁረጥ ወሰኑ። ሊከፋፍሉት ባቀዱት ዕለት እለት ሌሊት፣ ታናሿ የልጅ ልጃቸው አያት ሴትዋ ያብራራችበት ሕልም አለመች፤ የብርድ ልብሱ ዋጋ የሚመጣው የቤተሰቡን ታሪኮች አንድነት ከመጠበቅ መሆኑን፣ ልክ ስፌቱ ጨርቁን አንድ ላይ እንደያዘው። በሚቀጥለው ቀን ጠዋት፣ ልጅቷ ቤተሰቡን ብርድ ልብሱን አንድ ላይ ጠብቆ እንዲያቆይና ቤተሰብ ስብሰባዎችን በማዘጋጀት ቤተሰቡን በሙቀቱ ታጅፎ እያንዳንዱን ካሬ ታሪክ ለማጋራት ተራን በመቀያየር እንዲጠቀሙበት አሳመነቻቸው። ይህ ወግ የተለያ ቤተሰብ ከመቼውም ጊዜ የበለጠ አቀራረባቸውን አጠናከረ፣ በየዓመቱም አዲስ ካሬዎችን ጨምረው፣ የአያታቸውን የቤተሰብ ትዝታዎችን የመሰባሰብ ውርስ ቀጠሉት።",
      type: StoryType.fairyTale,
      topic: "Family",
      dateCreated: DateTime.now().subtract(const Duration(days: 22)),
      category: StoryCategory.family,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Family Tree",
      titleAm: "የቤተሰብ ዛፍ",
      contentEn:
          "In the center of a village stood an enormous oak tree that had witnessed generations of families grow, marry, and raise children. One day, a young boy named Tariku felt lonely and sat beneath the tree. \"I wish I had a bigger family,\" he sighed. Suddenly, a leaf fell on his lap, and as he touched it, he saw a vision of his great-grandfather as a young man, planting the tree. More leaves fell, each showing him ancestors he'd never known - brave warriors, skilled healers, and talented musicians. The final leaf showed his entire family lineage, connected like branches. When Tariku returned home, he told his mother about his visions. She smiled and took out an old family journal that confirmed his visions. She explained that their family wasn't small at all - it stretched back through time, and forward through him. From that day on, Tariku collected family stories and began recording them for future generations. He never felt lonely again, knowing he was part of something much larger - a living family tree with roots deep in the past and branches reaching into the future.",
      contentAm:
          "በአንድ መንደር መሃል ትውልዶች ሲያድጉ፣ ሲጋቡ እና ልጆችን ሲያሳድጉ የተመለከተ ግዙፍ የኦክ ዛፍ ቆሞ ነበር። አንድ ቀን፣ ታሪኩ የሚባል ወጣት ልጅ ብቸኝነት ተሰምቶት ከዛፉ በታች ተቀመጠ። \"ትልቅ ቤተሰብ ቢኖረኝ ኖሮ መልካም ነበር፣\" ብሎ አሰለቸው። ድንገት፣ አንድ ቅጠል በእጅ ሳንባው ላይ ወደቀ፣ ሲነካውም፣ ታላቅ አያቱ በወጣትነቱ ዛፉን ሲተክል ተመለከተ። ተጨማሪ ቅጠሎች ወደቁ፣ እያንዳንዳቸውም ፈጽሞ ያላወቃቸውን አያቶቹን አሳዩት - ጀግና ተዋጊዎች፣ ብልህ ፈዋሾች፣ እና ታላንት ያላቸው ሙዚቀኞች። የመጨረሻው ቅጠል እንደ ቅርንጫፎች የተገናኘውን የጠቅላላ ቤተሰብ ትውልዱን አሳየው። ታሪኩ ወደ ቤት ሲመለስ፣ ስለ ራእዮቹ እናቱን ነገራት። እናቱም ፈገግ ብላ ራእዮቹን የሚያረጋግጥ የድሮ የቤተሰብ መዝገብ አወጣች። የሚያብራራላት ቤተሰባቸው ምንም አይነት ትንሽ አለመሆኑን ነው - በጊዜ ወደ ኋላ የዘለቀ እና ከእሱ በኩል ወደፊት የሚዘልቅ። ከዚያን ቀን ጀምሮ፣ ታሪኩ የቤተሰብ ታሪኮችን ሰበሰበ እና ለወደፊት ትውልዶች መመዝገብ ጀመረ። ከዚያም ከትልቅ ነገር አንድ አካል መሆኑን በማወቅ - ስሮቹ በታሪክ የተዘረጉና ቅርንጫፎቹ ወደ ወደፊት የሚዘረጉ ሕያው የቤተሰብ ዛፍ መሆኑን አውቆ ብቸኝነት ተሰምቶት አያውቅም።",
      type: StoryType.fairyTale,
      topic: "Family",
      dateCreated: DateTime.now().subtract(const Duration(days: 27)),
      category: StoryCategory.family,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Patchwork Blanket",
      titleAm: "ያጣመረ ብርድ ልብስ",
      contentEn:
          "Every winter solstice, a grandmother added one square to her enormous patchwork blanket. Each piece of fabric had a story - a scrap from her son's wedding clothes, a piece of her daughter's first school uniform, her husband's favorite shirt now worn thin. The blanket grew for decades, becoming famous in their village for its beauty and size. When the grandmother passed away, her five children argued over who should inherit the precious blanket. Unable to agree, they decided to cut it into five equal pieces. The night before they planned to divide it, the youngest grandchild had a dream where her grandmother explained that the blanket's value came from keeping the family stories connected, just as the stitches held the fabric together. The next morning, the child convinced the family to keep the blanket whole and share it by taking turns hosting family gatherings where they would wrap themselves in its warmth and tell the stories behind each square. The tradition brought the extended family closer than ever before, and they added new squares each year, continuing their grandmother's legacy of weaving family memories together.",
      contentAm:
          "በየበጋ ወቅቱ የፀሐይ ዞሮ ኮከብ ሲመለስ፣ አንዲት አያት ሴት በሰፊ ያጣመረችው ብርድ ልብስ ላይ አንድ ካሬ ታክል ነበር። እያንዳንዱ የጨርቅ ቁራጭ ታሪክ ነበረው - ከወንድ ልጅዋ የሠርግ ልብስ ላይ የተቆረጠ፣ ከሴት ልጅዋ የመጀመሪያ የትምህርት ቤት ልብስ ላይ የተቆረጠ ቁራጭ፣ ያረጀው የባሏ ተወዳጅ ሸሚዝ። ብርድ ልብሱ ለአሥርት ዓመታት አደገ፣ በውበቱና በመጠኑም በመንደራቸው ዝናን አትረፈ። አያት ሴትዋ ከሞተች በኋላ፣ አምስቱ ልጆቿ ውድ ብርድ ልብሱን ማን ሊወርስ እንደሚገባው ተጨቃጨቁ። መስማማት ባለመቻላቸው፣ ወደ አምስት እኩል ክፍሎች ለመቁረጥ ወሰኑ። ሊከፋፍሉት ባቀዱት ዕለት እለት ሌሊት፣ ታናሿ የልጅ ልጃቸው አያት ሴትዋ ያብራራችበት ሕልም አለመች፤ የብርድ ልብሱ ዋጋ የሚመጣው የቤተሰቡን ታሪኮች አንድነት ከመጠበቅ መሆኑን፣ ልክ ስፌቱ ጨርቁን አንድ ላይ እንደያዘው። በሚቀጥለው ቀን ጠዋት፣ ልጅቷ ቤተሰቡን ብርድ ልብሱን አንድ ላይ ጠብቆ እንዲያቆይና ቤተሰብ ስብሰባዎችን በማዘጋጀት ቤተሰቡን በሙቀቱ ታጅፎ እያንዳንዱን ካሬ ታሪክ ለማጋራት ተራን በመቀያየር እንዲጠቀሙበት አሳመነቻቸው። ይህ ወግ የተለያ ቤተሰብ ከመቼውም ጊዜ የበለጠ አቀራረባቸውን አጠናከረ፣ በየዓመቱም አዲስ ካሬዎችን ጨምረው፣ የአያታቸውን የቤተሰብ ትዝታዎችን የመሰባሰብ ውርስ ቀጠሉት።",
      type: StoryType.fairyTale,
      topic: "Family",
      dateCreated: DateTime.now().subtract(const Duration(days: 22)),
      category: StoryCategory.family,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Seven Brothers",
      titleAm: "ሰባቱ ወንድማማቾች",
      contentEn:
          "Seven brothers lived in a house on a hillside, but they constantly fought and rarely cooperated. One day, their aging father called them together and handed each a single stick. \"Break it,\" he instructed. Each brother easily snapped his stick. Next, the father bound seven identical sticks together and challenged his strongest son to break the bundle. Despite his efforts, the bundle remained intact. \"My sons,\" said the father, \"alone you are easily broken, like these individual sticks. But together, supporting each other, you become unbreakable.\" The brothers didn't immediately change, but when drought threatened their crops, they had no choice but to work together. The eldest organized irrigation, the second designed water collection systems, the third monitored crops, the fourth prepared storage, the fifth traded for supplies, the sixth kept records, and the youngest maintained their tools. Not only did their farm survive, but it thrived beyond neighboring properties. The brothers discovered their unique strengths complemented each other perfectly, making them more successful together than they ever could be apart. From then on, the seven brothers became inseparable, and their family farm prospered for generations.",
      contentAm:
          "ሰባት ወንድማማቾች በኮረብታ ጎን ባለ ቤት ይኖሩ ነበር፣ ነገር ግን ሁልጊዜ ይጣሉ ነበር እና ሲተባበሩም ብዙም አይታዩም። አንድ ቀን፣ እየሸመገለ የሄደው አባታቸው አንድ ላይ ጠርቶ ለእያንዳንዳቸው አንድ አንድ በትር ሰጠ። \"ሰብሩት፣\" ብሎ አዘዛቸው። እያንዳንዱ ወንድም በትሩን በቀላሉ ሰበረው። ቀጥሎ፣ አባታቸው ተመሳሳይ ሰባት በትሮችን አንድ ላይ አሰርቶ እጅግ ጠንካራውን ልጁን ቋጠሮውን እንዲሰብር ፈታተነው። ቢጥርም፣ ቋጠሮው ሳይሰበር ቀረ። \"ልጆቼ፣\" አለ አባቱ፣ \"ብቻችሁን እንደነዚህ ነጠላ በትሮች በቀላሉ ትሰበራላችሁ። ነገር ግን አብራችሁ፣ እርስ በርሳችሁ ስትደጋገፉ፣ የማትሰበሩ ትሆናላችሁ።\" ወንድማማቾቹ ወዲያውኑ አልተቀየሩም፣ ሆኖም ድርቅ ሰብላቸውን ሲያስፈራራ፣ አብረው መስራት ካለበለዚያ አማራጭ አልነበራቸውም። ታላቁ ወንድም የመስኖ ሥራን አደራጀ፣ ሁለተኛው የውሃ ማሰባሰቢያ ዘዴዎችን ነደፈ፣ ሦስተኛው ሰብሎችን ተከታተለ፣ አራተኛው ማከማቻ አዘጋጀ፣ አምስተኛው ለአቅርቦቶች ንግድ አካሄደ፣ ስድስተኛው መዝገቦችን ጠበቀ፣ እና ታናሹ መሣሪያዎቻቸውን ጠገነ። እርሻቸው መትረፍ ብቻ ሳይሆን፣ ከአጎራባች ንብረቶች በላይ አደገ። ወንድማማቾቹ የተለዩ ጥንካሬዎቻቸው እርስ በርሱ በፍጹም እንደሚደጋገፉ ተማሩ፣ ይህም ለብቻቸው ሊሆኑ ከሚችሉት በላይ አብረው የበለጠ የተሳካላቸው ሆኑ። ከዚያን ጊዜ ጀምሮ፣ ሰባቱ ወንድማማቾች የማይነጣጠሉ ሆኑ፣ የቤተሰብ እርሻቸውም ለትውልዶች አደገ።",
      type: StoryType.fairyTale,
      topic: "Family",
      dateCreated: DateTime.now().subtract(const Duration(days: 17)),
      category: StoryCategory.family,
      hasBeenViewed: false,
    ));

    // Friendship fairy tales
    _stories.add(Story(
      titleEn: "The Odd Couple",
      titleAm: "አስቂኝ ጓደኞች",
      contentEn:
          "A neat-freak elephant and a messy monkey became roommates in the jungle's most popular treehouse. The elephant constantly cleaned with his trunk, while the monkey swung around dropping banana peels. \"Your bananas will attract ants!\" the elephant would trumpet. \"Your cleaning scares away fun!\" the monkey would tease. One rainy season, the treehouse began to leak. The elephant's trunk wasn't long enough to reach the ceiling, and the monkey's acrobatics couldn't hold repair tools. \"If you stand still and let me climb on your back,\" suggested the monkey, \"I can fix the roof.\" Working together, they repaired the treehouse, and afterward, the elephant realized having a little mess wasn't so bad, while the monkey created a special clean corner for his friend. Sometimes the friends who drive us crazy are exactly the ones we need.",
      contentAm:
          "በጣም ንጹህ የሚወድ ዝሆንና ቆሻሻን የማይፈራ ወንበር በጫካው ውስጥ በጣም ታዋቂ በሆነ የዛፍ ቤት ውስጥ መኖር ጀመሩ። ዝሆኑ ሁልጊዜ በአፍንጫው ያጸዳ ነበር፣ ወንበሩ ደግሞ ሲዘው የሙዝ ልጣጭ እየጣለ ይንሳፈፍ ነበር። \"የእርስዎ ሙዝ ጭንቅላቶችን ይስባል!\" ሲል ዝሆኑ ይጮህ ነበር። \"ማጽዳትዎ ደስታን ያስፈራል!\" ሲል ወንበሩ ያሾፍ ነበር። በአንድ የዝናብ ወቅት፣ የዛፍ ቤቱ ማፍሰስ ጀመረ። የዝሆኑ አፍንጫ ወደ ጣሪያው ለመድረስ በቂ አልነበረም፣ እና የወንበሩ እንቅስቃሴዎች የጥገና መሳሪያዎችን መያዝ አልቻለም። \"አንተ ቆመህ በጀርባዬ ላይ እንድወጣ ብታደርግ፣\" በማለት ወንበሩ ሃሳብ አቀረበ፣ \"ጣሪያውን መጠገን እችላለሁ።\" አብረው በመስራት፣ የዛፍ ቤቱን አሻሻሉት፣ ከዚያም በኋላ ትንሽ ቆሻሻ ሊኖር እንደሚችል ዝሆኑ ተገነዘበ፣ ወንበሩም ለጓደኛው ልዩ ንጹህ ማዕዘን ፈጠረ። አንዳንድ ጊዜ እኛን የሚያሳብዱ ጓደኞች ልክ እኛ የምንፈልጋቸው ናቸው።",
      type: StoryType.fairyTale,
      topic: "Friendship",
      dateCreated: DateTime.now().subtract(const Duration(days: 3)),
      category: StoryCategory.friendship,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Great Laughing Contest",
      titleAm: "ታላቁ የሳቅ ውድድር",
      contentEn:
          "Two best friends, a giraffe and a hedgehog, entered the forest's annual laughing contest. The giraffe practiced stretching her neck to make funny faces, while the hedgehog rehearsed rolling into a ball and bouncing around. On competition day, the giraffe's routine failed to impress the judges, and the hedgehog accidentally rolled into a puddle. Both were devastated. Back at home, the hedgehog tried to cheer up the giraffe by balancing apples on his spines. The giraffe, still sad, accidentally sneezed, sending the apples flying everywhere. They looked at each other in shock before bursting into uncontrollable laughter. The next year, they performed this routine together and won first prize. The judges said they'd never seen such genuine joy between friends. Victory wasn't about being the funniest, but about finding laughter in each other's company.",
      contentAm:
          "ሁለት የቅርብ ጓደኞች፣ ቁራና ይኸውም ጀብ፣ በየዓመቱ በሚከናወነው የደን የሳቅ ውድድር ተሳተፉ። ቁራው አስቂኝ ገጽታዎችን ለመስራት አንገቱን እየዘረጋ ይለማመድ ነበር፣ ጀቡ ደግሞ በኳስ መሰል ሆኖ እየተንከባለለ ዙሪያውን መዝለል ይለማመድ ነበር። በውድድሩ ቀን፣ የቁራው ዝግጅት ዳኞችን ማስደመም አልቻለም፣ እና ጀቡ በድንገት ወደ ውሃ ጭቃ ውስጥ ተንከባለለ። ሁለቱም ተደናግጠው ነበር። ወደ ቤት ሲመለሱ፣ ጀቡ ቁራውን ለማስደሰት በአሜባዎቹ ላይ ፖም ስንዴ በማስቀመጥ ሞከረ። አሁንም ያዘነው ቁራው በድንገት አስነጠሰ፣ የታቀሙትን ፖም አፕሎችም በሁሉም አቅጣጫ በማበተን። ሁለቱም በድንጋጤ እርስ በርሳቸው ተመለከቱ፣ ከዚያም በማይቆጣጠሩት ሳቅ ተውጠው እና ተያዙ። በሚቀጥለው ዓመት፣ ይህንን ዝግጅት አብረው አቀረቡና የመጀመሪያውን ሽልማት አገኙ። ዳኞቹ በጓደኞች መካከል ይህን ያህል እውነተኛ ደስታ ፈጽሞ እንዳላዩ ተናገሩ። ድልም ትልቁን አስቂኝ ሳይሆን፣ በአንድነት ሳቅ ማግኘት ነበር።",
      type: StoryType.fairyTale,
      topic: "Friendship",
      dateCreated: DateTime.now().subtract(const Duration(days: 2)),
      category: StoryCategory.friendship,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Forgetful Friends",
      titleAm: "ረሳተኛዎቹ ጓደኞች",
      contentEn:
          "Ato Doro the rooster had the best memory in the village, while his friend Miss Duba the pigeon couldn't remember what she had for breakfast. \"I'll help you remember things,\" Ato Doro promised, creating elaborate memory systems. He gave her colored strings to tie around her feet - blue for market day, red for watering plants. One morning, Ato Doro himself forgot to crow, oversleeping and causing the whole village to be late. Miss Duba flew to his window, \"Wake up! You forgot to crow!\" she shouted. \"How did you remember?\" asked the astonished rooster. \"I didn't need strings or systems. Friends remember what's important to other friends,\" she smiled. From that day on, they helped each other remember - sometimes with systems, sometimes with heart. And they always remembered to laugh about their forgetfulness.",
      contentAm:
          "አቶ ዶሮ ዓውድማው በመንደሩ ውስጥ ምርጥ ማስታወስ የነበረው ሲሆን፣ ጓደኛው ሚስ ዱባ እርግቧ ግን ለቁርስ ምን እንደበላች መታወስ አትችልም። \"ነገሮችን እንድታስታውሺ እረዳሻለሁ፣\" አለ አቶ ዶሮ፣ ረቂቅ የማስታወሻ ሥርዓቶችን በመፍጠር። አጓጉል ገመዶችን ሰጣት እግሮቿ ዙሪያ እንድታሰር - ሰማያዊ ለገበያ ቀን፣ ቀይ ለተክሎች ማጠጫ። አንድ ጠዋት፣ አቶ ዶሮ ራሱ መጮህ ረሳ፣ አልተነሳም ስለዚህም መላው መንደሩ ዘግይቷል። ሚስ ዱባ ወደ መስኮቱ በረራች፣ \"ተነሳ! መጮህ ረስተሃል!\" ብላ ጮኸች። \"እንዴት አስታወስሽ?\" ብሎ ጠየቀ ዓውድማው በመገረም። \"ገመዶችም ሆነ ሥርዓቶች አላስፈለጉኝም። ጓደኛሞች ለሌሎች ጓደኛሞች አስፈላጊ የሆነውን ነገር ያስታውሳሉ\" ብላ ፈገግ አለች። ከዚያን ቀን ጀምሮ፣ እርስ በርሳቸው ለማስታወስ ረዳዱ - አንዳንድ ጊዜ በሥርዓቶች፣ አንዳንድ ጊዜ በልብ። እና ሁልጊዜም ስለመርሳታቸው ለመሳቅ ይታወሱ ነበር።",
      type: StoryType.fairyTale,
      topic: "Friendship",
      dateCreated: DateTime.now().subtract(const Duration(days: 8)),
      category: StoryCategory.friendship,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Upside-Down Friends",
      titleAm: "ቅልጥ ያሉ ጓደኞች",
      contentEn:
          "A bat and a sloth became friends despite their opposite schedules - the bat active at night, the sloth barely moving by day. \"How can we ever spend time together?\" they wondered. The solution came when the sloth suggested hanging from the same branch. Upside down, they could chat during the brief twilight hours when both were awake. One evening, a sudden storm brought unexpected benefits: the bat's echolocation helped them navigate through the darkness, while the sloth's knowledge of secure branches kept them safe from falling. \"We're the perfect team!\" laughed the bat. \"Yes,\" agreed the sloth slowly, \"because our differences make us stronger together.\" Their upside-down friendship showed the entire forest that sometimes the most unlikely companions make the most devoted friends, especially when they find creative ways to meet in the middle.",
      contentAm:
          "አናጢና ስሎዝ በተቃራኒ መርሃግብራቸው ቢሆንም ጓደኛሞች ሆኑ - አናጢው በሌሊት ንቁ፣ ስሎዙ በቀን በዘገምተኛ እንቅስቃሴ። \"እንዴት ጊዜ አብረን ልናሳልፍ እንችላለን?\" ብለው ተጠየቁ። መፍትሄው የመጣው ስሎዙ በተመሳሳይ ቅርንጫፍ ላይ መንጠልጠል ሲጠቁም ነበር። ተገልብጠው ሆነው ሁለቱም ንቁ በሆኑበት አጭር የምሽት ሰዓታት መወያየት ችለዋል። አንድ ምሽት፣ ድንገተኛ ዝናብ ያልተጠበቀ ጥቅም አመጣ: የአናጢው ድምጽ ማግኘቻ በጨለማው ውስጥ እንዲጓዙ ረዳቸው፣ የስሎዙ ደህንነት ስላላቸው ቅርንጫፎች እውቀትም ከመውደቅ ጠበቃቸው። \"እኛ ፍጹም ቡድን ነን!\" አለ አናጢው እየሳቀ። \"አዎን\" ብሎ ተስማማ ስሎዙ በቀስታ፣ \"ምክንያቱም ልዩነቶቻችን አብረን ይበልጥ ጠንካራ ያደርጉናል።\" በቅልጥም የሆነው ወዳጅነታቸው ለመላው ጫካ አሳየ፣ አንዳንድ ጊዜ በጣም ሊጓደኙ የማይችሉ መስለው የሚታዩ፣ በጣም ታማኝ ጓደኞች እንደሚሆኑ፣ በተለይም ለመገናኘት ፈጠራዊ መንገዶችን ሲያገኙ።",
      type: StoryType.fairyTale,
      topic: "Friendship",
      dateCreated: DateTime.now().subtract(const Duration(days: 5)),
      category: StoryCategory.friendship,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Musical Mismatch",
      titleAm: "የሙዚቃ አለመጣጣም",
      contentEn:
          "A noisy hyena who loved to laugh-sing joined a forest band with a perfectionist nightingale. \"Your howling is off-key!\" complained the nightingale. \"Your singing is boring!\" retorted the hyena. During the forest's annual concert, disaster struck when the nightingale lost her voice from rehearsing too much, and the hyena froze with stage fright. In panic, the hyena let out a nervous laugh, which the audience found hilarious. The nightingale, unable to sing properly, began humming along to the hyena's laughs, creating an unexpectedly catchy rhythm. Their performance brought the house down. Later, the nightingale admitted, \"Perhaps perfect isn't always best,\" while the hyena acknowledged, \"And sometimes a little structure improves the chaos.\" They created a new musical style called \"Laugh-Harmony\" that became famous throughout the animal kingdom, proving that when friends embrace their differences, magic happens.",
      contentAm:
          "በሳቅ መዝፈን የሚወድ ጮኸኛ ጅብ ከፍጹምነት ፈላጊ ሆነው ዝምታን ከሚወዱ አንደበት ፍቅረኛ ወፍ ጋር የደን ባንድ ተቀላቀለ። \"ጩኸትህ ከዜማው ውጪ ነው!\" በማለት አንደበት ፍቅረኛ ወፏ አማረረች። \"ዘፈንህ አሰልቺ ነው!\" በማለት ጅቡ መለሰላት። በደኑ ዓመታዊ ኮንሰርት ላይ፣ አንደበት ፍቅረኛዋ በብዙ ልምምድ ምክንያት ድምጿን ስታጣ እና ጅቡ ደግሞ በመድረክ ላይ ፍርሃት ሲገታው አስከፊ ሁኔታ ተከሰተ። በጭንቀት፣ ጅቡ ነርቨስ የሆነ ሳቅ አሰማ፣ ይህም ታዳሚዎቹን አስቃቸው። አንደበት ፍቅረኛዋ በአግባቡ መዝፈን ባለመቻሏ፣ ከጅቡ ሳቆች ጋር ማላዘን ጀመረች፣ ይህም ያልተጠበቀ ሙዚቃን እና ውዝዋዜን ፈጠረ። ዝግጅታቸውም ሁሉንም አስደመመ። በኋላ፣ አንደበት ፍቅረኛዋ አመነች፣ \"ምናልባት ፍጹምነት ሁልጊዜ የተሻለ አይደለም፣\" በማለት፣ ጅቡም \"አንዳንድ ጊዜ ትንሽ አወቃቀር ትርምስን ያሻሽላል\" ብሎ አመነ። \"የሳቅ-ሀርሞኒ\" የተባለ አዲስ የሙዚቃ ዘይቤ ፈጠሩ፣ በእንስሳት መንግስት ሁሉ ዝናን አተረፈ፣ ጓደኛሞች ልዩነታቸውን ሲቀበሉ ድንቅ ነገር እንደሚፈጠር ያረጋገጠ።",
      type: StoryType.fairyTale,
      topic: "Friendship",
      dateCreated: DateTime.now().subtract(const Duration(days: 6)),
      category: StoryCategory.friendship,
      hasBeenViewed: false,
    ));

    // Animal riddles
    _stories.add(Story(
      titleEn: "The Silent Hunter",
      titleAm: "ጸጥተኛው አዳኝ",
      contentEn:
          "I prowl through the night with eyes that glow,\nSilent as shadows wherever I go.\nWith whiskers and claws and fur so sleek,\nI hunt for my prey but never speak.\nWhat am I?",
      contentAm:
          "በሌሊት እንቅልፍ የለኝም ዓይኖቼ ይፈካሉ,\nእንደ ጥላ ዝም ብዬ በሁሉም ቦታ እሄዳለሁ።\nበጢሞቼ፣ በጥፍሮቼ እና በለስላሳ ቀጥቃጫ ስታየኝ,\nምግቤን አደን እንጂ ፈጽሞ አልናገር።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 12)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Gentle Giant",
      titleAm: "ትሁት ግዙፍ",
      contentEn:
          "I'm the largest creature on land today,\nWith a trunk for a nose I spray and play.\nMy big ears flap like fans in the heat,\nAnd my memory is something you cannot beat.\nWhat am I?",
      contentAm:
          "በምድር ላይ ዛሬ ትልቁ ፍጡር ነኝ,\nአፍንጫዬን አንጋጥቼ ውሃ እጨፍራለሁ።\nትልልቅ ጆሮዎቼን እንደ ማቀዝቀዣ አወዛውዛቸዋለሁ,\nእኔ ያስታወስኩትን እናንተ አታስታውሱትም።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 10)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Armored One",
      titleAm: "ጥብቅ የሆነው",
      contentEn:
          "I carry my home wherever I roam,\nInside it I hide when danger comes.\nMy pace is not quick, I'm patient and slow,\nLiving for years, that's what I know.\nWhat am I?",
      contentAm:
          "ቤቴን ይዤ በሄድኩበት ቦታ ሁሉ እዞራለሁ,\nአደጋ ሲመጣ በውስጡ እደበቃለሁ።\nፍጥነቴ አይደለም ፈጣን፣ ታጋሽና ዝግተኛ ነኝ,\nብዙ ዓመታት የምኖር ነኝ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 14)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Leaper",
      titleAm: "ዘላዩ",
      contentEn:
          "I hop and I jump on powerful hind legs,\nIn a pouch on my front, my baby I peg.\nFrom Australia I come, with a powerful tail,\nAt boxing and jumping, I never fail.\nWhat am I?",
      contentAm:
          "በኋላ እግሮቼ ጠንካራ ሁኜ እዘላለሁ,\nበከርሴ ላይ ባለው ኪስ ውስጥ ልጄን አስቀምጣለሁ።\nከአውስትራሊያ የመጣሁ፣ ጠንካራ ጅራት ያለኝ,\nበቡጢ መምታትና በመዝለል አልሸነፍም።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 7)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Striped Runner",
      titleAm: "መስመሮች ያሉት ሯጭ",
      contentEn:
          "Black and white stripes cover my hide,\nIn Africa's plains I run and I stride.\nLike a horse I look, but I'm not quite the same,\nNo rider can tame me or call me by name.\nWhat am I?",
      contentAm:
          "ጥቁርና ነጭ መስመሮች ሰውነቴን ይሸፍናሉ,\nበአፍሪካ ሜዳዎች ላይ እሮጣለሁ።\nእንደ ፈረስ እመስላለሁ፣ ግን ተመሳሳይ አይደለሁም,\nምንም ጋላቢ ሊያሰልጠነኝ ወይም በስሜ ሊጠራኝ አይችልም።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 9)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Wise Bird",
      titleAm: "ጥበበኛ ወፍ",
      contentEn:
          "I turn my head almost all the way around,\nIn darkness I hunt without a sound.\nWho-who-who, you'll hear me call,\nPerched in a tree so wise and tall.\nWhat am I?",
      contentAm:
          "ራሴን ከአንድ አቅጣጫ ወደ ሌላው ማዞር እችላለሁ,\nበጨለማ ውስጥ ድምፅ ሳላሰማ አድናለሁ።\nሁ-ሁ-ሁ፣ ድምፄን ትሰማላችሁ,\nጥበበኛና ረጅም ዛፍ ላይ ተቀምጬ አያችሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 11)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Buzzing Worker",
      titleAm: "ድምፅ የሚያሰማው ሰራተኛ",
      contentEn:
          "I fly from flower to flower all day,\nCollecting nectar along the way.\nMy home is a hive where I store gold so sweet,\nMake me angry and I'll give you a treat!\nWhat am I?",
      contentAm:
          "ቀኑን ሙሉ ከአበባ ወደ አበባ እበራለሁ,\nበመንገዴ ላይ ሁሉ ማር እሰበስባለሁ።\nቤቴ ቀፎ ነው፣ ጣፋጭ ወርቅ አከማቻለሁ,\nብታስቆጣኝ ስጦታ አበረክትልሃለሁ!\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 8)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The King's Mane",
      titleAm: "የንጉሱ ሊባ",
      contentEn:
          "I'm known as the king of beasts so grand,\nMy roar can be heard across the land.\nWith golden fur and a majestic mane,\nOver my pride I proudly reign.\nWhat am I?",
      contentAm:
          "እንደ አውሬዎች ንጉስ የምታወቅ ነኝ,\nየእኔ ጩኸት በምድሪቱ ላይ ሁሉ ይሰማል።\nወርቃማ ፀጉርና ደማቅ ሊባ ያለኝ,\nበእኔ ጎሳ ላይ በኩራት እገዛለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 15)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Water Dweller",
      titleAm: "የውሃ ነዋሪ",
      contentEn:
          "In the ocean deep I make my home,\nWith eight long arms I like to roam.\nI can change my color in a blink,\nI'm smarter than most people think.\nWhat am I?",
      contentAm:
          "በጥልቁ ውቅያኖስ ውስጥ ቤቴን እሰራለሁ,\nበስምንት ረጃጅም ክንዶቼ መዞር እወዳለሁ።\nቀለሜን በአይን ፍጥነት መለወጥ እችላለሁ,\nከሚያስቡት በላይ ብልህ ነኝ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 5)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Desert Ship",
      titleAm: "የበረሃ መርከብ",
      contentEn:
          "Through hot sands I trek for miles and miles,\nWith humps on my back and toothy smiles.\nLittle water I need, I'm built for the heat,\nIn desert journeys, I can't be beat.\nWhat am I?",
      contentAm:
          "በሞቃት አሸዋ ላይ ብዙ ማይሎችን እጓዛለሁ,\nበጀርባዬ ላይ ጉብጦችና ጥርስ ያለው ፈገግታ አለኝ።\nትንሽ ውሃ ብቻ ነው የሚያስፈልገኝ፣ ለሙቀት የተፈጠርኩ ነኝ,\nበበረሃ ጉዞዎች፣ ማንም ሊረታኝ አይችልም።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Animals",
      dateCreated: DateTime.now().subtract(const Duration(days: 13)),
      category: StoryCategory.animals,
      hasBeenViewed: false,
    ));

    // Nature riddles
    _stories.add(Story(
      titleEn: "The Mountain Giant",
      titleAm: "የተራራ ענק",
      contentEn:
          "I stand tall and proud, reaching for the sky,\nSnow caps my peak where eagles fly.\nFrom my sides flow rivers clear and cold,\nI've been here since the world was old.\nWhat am I?",
      contentAm:
          "ረጅም እና ኩራተኛ ሆኜ ቆማለሁ፣ ወደ ሰማይ እድጋለሁ,\nበአናቴ ላይ የበረዶ ቆብ አለኝ፣ ንስሮች በላዬ ላይ ይበራሉ።\nከጎኖቼ ንፁሕና ቀዝቃዛ ወንዞች ይፈሳሉ,\nዓለም ከተፈጠረ ጀምሮ እዚህ ነበርኩ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 20)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Whispering Dancer",
      titleAm: "የሚሾካሾክ ፈንጠዝያ",
      contentEn:
          "I sway and I dance with every breeze,\nMy green hands reach out from sturdy trees.\nIn autumn I change to red and gold,\nThen fall to the ground when the weather turns cold.\nWhat am I?",
      contentAm:
          "በእያንዳንዱ ነፋስ እወዛወዛለሁ እና እደንሳለሁ,\nአረንጓዴ እጆቼን ከጠንካራ ዛፎች አስረዝማለሁ።\nበበልግ ወቅት ወደ ቀይና ወርቃማ እቀያየራለሁ,\nከዚያም አየሩ ሲቀዘቅዝ ወደ መሬት እወድቃለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 17)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Sky's Tears",
      titleAm: "የሰማይ እንባዎች",
      contentEn:
          "I fall from clouds but I'm not snow,\nI quench the thirst of plants that grow.\nI make puddles where children play,\nAnd wash the dusty world away.\nWhat am I?",
      contentAm:
          "ከደመናዎች እወድቃለሁ ግን በረዶ አይደለሁም,\nየሚያድጉ ተክሎችን ጥም አረካለሁ።\nልጆች የሚጫወቱበትን ጉድጓዶች እሰራለሁ,\nየተኳሸው አለምን እታጠባለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 21)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Silent Blanket",
      titleAm: "ጸጥተኛ ብርድ ልብስ",
      contentEn:
          "I cover the land in purest white,\nFalling softly through the night.\nChildren make angels where I lay,\nBut sunshine makes me go away.\nWhat am I?",
      contentAm:
          "ምድርን በጣም ንጹህ ነጭ ሆኜ አሸፍናለሁ,\nበሌሊት በለዝብ እወድቃለሁ።\nልጆች በማረፍብት ቦታ መላእክት ይሰራሉ,\nግን ፀሐይ እኔን ታጠፋኛለች።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 19)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Angry Roar",
      titleAm: "የቁጣ ጩኸት",
      contentEn:
          "I flash bright in darkened skies,\nMy voice makes babies close their eyes.\nI come with storms, with wind and rain,\nThen quickly disappear again.\nWhat am I?",
      contentAm:
          "በጨለመው ሰማይ ላይ በብርሃን እፈካለሁ,\nድምፄ ሕፃናትን አይናቸውን እንዲዘጉ ያደርጋል።\nከነፋስና ዝናብ ጋር በማዕበል እመጣለሁ,\nከዚያም በፍጥነት ደግሞ እጠፋለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 18)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Invisible Force",
      titleAm: "የማይታየው ሃይል",
      contentEn:
          "You feel me on your skin but cannot see,\nI make the leaves dance upon the tree.\nI help birds soar high in the air,\nAnd spread seeds and pollen everywhere.\nWhat am I?",
      contentAm:
          "በቆዳህ ላይ ትሰማኛለህ ግን ልታየኝ አትችልም,\nቅጠሎችን በዛፍ ላይ እንዲደንሱ አደርጋለሁ።\nወፎች ከፍ ብለው እንዲበሩ እረዳቸዋለሁ,\nዘሮችንና ብናኝንም በየቦታው እበትናለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 23)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Blue Ceiling",
      titleAm: "ሰማያዊ ጣሪያ",
      contentEn:
          "I stretch above as far as you see,\nBirds and planes pass through me.\nBy day I'm blue, by night I'm black,\nI hold the stars and moon on my back.\nWhat am I?",
      contentAm:
          "እስከምታየው ድረስ ከላይ እተጣጠፋለሁ,\nወፎችና አውሮፕላኖች በእኔ ውስጥ ያልፋሉ።\nበቀን ሰማያዊ ነኝ፣ በሌሊት ጥቁር ነኝ,\nከዋክብትንና ጨረቃን በጀርባዬ ላይ እይዛለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 16)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));

    _stories.add(Story(
      titleEn: "The Rolling Hills",
      titleAm: "የሚንከባለሉ ኮረብታዎች",
      contentEn:
          "I move across the sky, fluffy and white,\nChanging shapes from morning till night.\nSometimes I turn dark and heavy with rain,\nThen pour down water again and again.\nWhat am I?",
      contentAm:
          "በሰማይ ላይ እንቀሳቀሳለሁ፣ ለስላሳና ነጭ,\nከጠዋት እስከ ሌሊት ቅርጾችን እቀያይራለሁ።\nአንዳንድ ጊዜ ጨለምተኛና በዝናብ ከባድ እሆናለሁ,\nከዚያም ውሃን እንደገና እና እንደገና አፈሳለሁ።\nእኔ ምንድን ነኝ?",
      type: StoryType.riddle,
      topic: "Nature",
      dateCreated: DateTime.now().subtract(const Duration(days: 24)),
      category: StoryCategory.nature,
      hasBeenViewed: false,
    ));
  }

  List<Story> getStoriesByCategory(StoryCategory category) {
    return _stories.where((story) => story.category == category).toList()
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
  }

  List<Story> getFeaturedStories() {
    return _stories.where((story) => story.isFeatured).toList()
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
  }

  void _initializeGemini() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    // Debug print API key (masked)
    if (apiKey != null && apiKey.length > 8) {
      debugPrint(
          'API Key loaded (showing first 8 chars): ${apiKey.substring(0, 8)}...');
    } else {
      debugPrint('API Key issue - using fallback method');
      // Use a fallback key if somehow the main.dart key didn't register
      dotenv.env['GEMINI_API_KEY'] = 'AIzaSyDv0foqdQQAmm76e02XlcT0fzGRO8xJDLo';
    }

    // Get the key again in case we just set the fallback
    final finalApiKey = dotenv.env['GEMINI_API_KEY'];
    if (finalApiKey == null || finalApiKey.isEmpty) {
      _error = 'API key configuration issue, please restart the app';
      return;
    }

    // Try creating the model with newest models first
    final modelNames = ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-pro'];

    try {
      // Use the best model for our use case
      _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: finalApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.2, // Lower temperature for more accurate content
          topP: 0.8,
          topK: 40,
          maxOutputTokens: 2048, // Allow longer outputs
        ),
      );
      debugPrint('Successfully initialized with model: gemini-1.5-pro');
      return; // Exit once successful
    } catch (e) {
      debugPrint('Error with primary model: ${e.toString()}');
      // Fall back to older models if needed
      for (final modelName in modelNames) {
        try {
          debugPrint('Trying to initialize with fallback model: $modelName');
          _model = GenerativeModel(
            model: modelName,
            apiKey: finalApiKey,
          );
          debugPrint('Successfully initialized with model: $modelName');
          return; // Exit once successful
        } catch (e) {
          debugPrint('Error with model $modelName: ${e.toString()}');
          // Continue to the next model name if this one fails
        }
      }
    }

    // If we get here, all model attempts failed
    _error =
        'Failed to initialize any Gemini model. Please check your API key.';
  }

  Future<Story?> generateStory({
    required StoryType type,
    required String topic,
    required AgeGroup ageGroup,
    bool isAmharicInput = false,
  }) async {
    if (topic.isEmpty) {
      return null;
    }

    if (_dataSavingMode) {
      return null;
    }

    final prompt = _buildPrompt(
      type: type,
      topic: topic,
      ageGroup: ageGroup,
      isAmharicInput: isAmharicInput,
    );

    // Generate content from the API
    try {
      _isLoading = true;
      notifyListeners();

      // If the API key isn't working or the model is not initialized properly,
      // we'll return a predefined response instead of hanging indefinitely
      if (_model == null) {
        _reinitializeGemini();

        // If still null after re-initialization, use fallback content
        if (_model == null) {
          await Future.delayed(const Duration(seconds: 2)); // Simulate API call

          // Create a fallback story
          final fallbackStory = _createFallbackStory(type, topic);
          _stories.add(fallbackStory);

          _error = '';
          _isLoading = false;
          notifyListeners();
          return fallbackStory;
        }
      }

      // Add timeout to the API call
      final response =
          await _model?.generateContent([Content.text(prompt)]).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
              'The content generation timed out. Creating a fallback story instead.');
        },
      );

      final responseText = response?.text;

      if (responseText == null || responseText.isEmpty) {
        // Use fallback content if the API response is empty
        final fallbackStory = _createFallbackStory(type, topic);
        _stories.add(fallbackStory);

        _error = '';
        _isLoading = false;
        notifyListeners();
        return fallbackStory;
      }

      // Parse the response
      Story? story = _parseResponse(
        type: type,
        topic: topic,
        response: responseText,
      );

      // If parsing fails, use a fallback story
      story ??= _createFallbackStory(type, topic);

      _stories.add(story);
      _error = '';
      _isLoading = false;
      notifyListeners();
      return story;
    } catch (e) {
      debugPrint('Error generating content: $e');

      // Create a fallback story on error
      final fallbackStory = _createFallbackStory(type, topic);
      _stories.add(fallbackStory);

      _error = '';
      _isLoading = false;
      notifyListeners();
      return fallbackStory;
    }
  }

  // Re-initialize the Gemini API with a simplified approach
  void _reinitializeGemini() {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('API key not found');
        return;
      }

      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );
      debugPrint('Re-initialized Gemini API with gemini-pro model');
    } catch (e) {
      debugPrint('Failed to re-initialize Gemini API: $e');
    }
  }

  // Create a fallback story when the API doesn't respond
  Story _createFallbackStory(StoryType type, String topic) {
    if (type == StoryType.fairyTale) {
      return Story(
        titleEn: "The Magic of $topic",
        titleAm: "የ$topic ድንቅ ተረት",
        contentEn:
            "Once upon a time in a faraway land, there was a magical $topic that brought joy to everyone who encountered it. Children would come from far and wide to see it, and adults would remember the wonder of their childhood. The $topic had a special power that could make anyone smile, even on their darkest days. This is why we must always appreciate the simple things in life, for sometimes they hold the greatest magic of all.",
        contentAm:
            "አንድ ጊዜ በሩቅ ምድር ውስጥ፣ ለሚያገኘው ሁሉ ደስታን የሚሰጥ አንድ ድንቅ $topic ነበር። ልጆች እሱን ለማየት ከሩቅ ይመጡ ነበር፣ ትልልቆችም የልጅነታቸውን ድንቅ ነገር ያስታውሱ ነበር። ይህ $topic በጨለማ ቀናቸው እንኳ ማንኛውንም ሰው ሊያስፈነዳ የሚችል ልዩ ኃይል ነበረው። ለዚህ ነው በሕይወት ውስጥ ያሉትን ቀላል ነገሮች ሁልጊዜ ማድነቅ ያለብን፣ አንዳንድ ጊዜ እነሱ ከሁሉም በላይ ታላቁን ድንቅ ነገር ይይዛሉ።",
        type: type,
        topic: topic,
        dateCreated: DateTime.now(),
        category: _getCategoryFromTopic(topic, type),
        hasBeenViewed: false,
      );
    } else {
      return Story(
        titleEn: "The $topic Riddle",
        titleAm: "የ$topic እንቆቅልሽ",
        contentEn:
            "I can be found in $topic, but I'm not always visible. The more you look for me, the harder I am to find. What am I?",
        contentAm:
            "በ$topic ውስጥ ልገኝ እችላለሁ፣ ነገር ግን ሁልጊዜ የማይታይ ነኝ። የበለጠ የፈለግኸኝ ቁጥር፣ ለማግኘት የበለጠ አስቸጋሪ እሆናለሁ። እኔ ምንድን ነኝ?",
        type: type,
        topic: topic,
        answerEn: "Meaning",
        answerAm: "ትርጉም",
        dateCreated: DateTime.now(),
        category: _getCategoryFromTopic(topic, type),
        hasBeenViewed: false,
      );
    }
  }

  String _buildPrompt({
    required StoryType type,
    required String topic,
    required AgeGroup ageGroup,
    bool isAmharicInput = false,
  }) {
    final isStory = type == StoryType.fairyTale;
    final isKids = ageGroup == AgeGroup.children;
    final isAmharic = isAmharicInput;

    // Build the base prompt
    String basePrompt = '''
You are a master storyteller specializing in bilingual ${isStory ? 'FairyTales' : 'riddles'} in English and Amharic. 
    ''';

    // Add specific instructions based on type
    if (isStory) {
      basePrompt += '''
Create a captivating FairyTale about "$topic" with the following structure:
1. English title (creative and engaging)
2. Amharic title (culturally appropriate translation)
3. English content (300-400 words, engaging narrative with a beginning, middle, and end)
4. Amharic content (faithful translation of the English story)

Important guidelines for the Amharic text:
- Ensure grammatical correctness and proper word order
- Use idiomatic expressions recognized by native speakers
- Avoid direct word-for-word translations; maintain cultural relevance
- Make sure the text flows naturally in Amharic
- Use Ethiopic script (Fidel)
- For a children's story: use simpler language, more repetition, and clear moral lessons
''';
    } else {
      basePrompt += '''
Create an intriguing riddle about "$topic" with the following structure:
1. English title (creative and engaging)
2. Amharic title (culturally appropriate translation)
3. English riddle (clever, concise, and challenging)
4. Amharic riddle (faithful translation that works in Amharic culture)
5. English answer (short and specific)
6. Amharic answer (accurate translation)

Important guidelines for the Amharic text:
- Ensure the riddle makes sense in Amharic cultural context
- Use wordplay that works in Amharic, not just direct translation
- Ensure grammatical correctness and proper word order
- Make sure the text flows naturally in Amharic
- Use Ethiopic script (Fidel)
- For a children's riddle: use simpler language and more obvious clues
''';
    }

    // Add general quality guidelines
    basePrompt += '''
General requirements:
1. The Amharic text should read naturally to native speakers
2. Incorporate Ethiopian cultural elements where appropriate
3. Structure your response in clear sections with labels
4. ${isKids ? 'Make the content appropriate for children aged 5-12' : 'Make the content engaging for all ages'}
5. ${isAmharic ? 'Since the original topic was provided in Amharic, ensure special attention to cultural nuances' : ''}

Response format:
ENGLISH_TITLE: [Title in English]
AMHARIC_TITLE: [Title in Amharic]
ENGLISH_CONTENT: [Content in English]
AMHARIC_CONTENT: [Content in Amharic]
${!isStory ? 'ENGLISH_ANSWER: [Answer in English]\nAMHARIC_ANSWER: [Answer in Amharic]' : ''}
''';

    return basePrompt;
  }

  Story? _parseResponse({
    required StoryType type,
    required String topic,
    required String response,
  }) {
    try {
      final lines = response.split('\n');
      String titleEn = '';
      String titleAm = '';
      String contentEn = '';
      String contentAm = '';
      String answerEn = '';
      String answerAm = '';

      bool isReadingContentEn = false;
      bool isReadingContentAm = false;

      for (final line in lines) {
        if (line.startsWith('ENGLISH_TITLE:')) {
          titleEn = line.substring('ENGLISH_TITLE:'.length).trim();
        } else if (line.startsWith('AMHARIC_TITLE:')) {
          titleAm = line.substring('AMHARIC_TITLE:'.length).trim();
        } else if (line.startsWith('ENGLISH_CONTENT:')) {
          isReadingContentEn = true;
          contentEn = line.substring('ENGLISH_CONTENT:'.length).trim();
        } else if (line.startsWith('AMHARIC_CONTENT:')) {
          isReadingContentEn = false;
          isReadingContentAm = true;
          contentAm = line.substring('AMHARIC_CONTENT:'.length).trim();
        } else if (line.startsWith('ENGLISH_ANSWER:')) {
          isReadingContentAm = false;
          answerEn = line.substring('ENGLISH_ANSWER:'.length).trim();
        } else if (line.startsWith('AMHARIC_ANSWER:')) {
          answerAm = line.substring('AMHARIC_ANSWER:'.length).trim();
        } else if (isReadingContentEn) {
          contentEn += '\n$line';
        } else if (isReadingContentAm) {
          contentAm += '\n$line';
        }
      }

      // Clean up the content to remove any extra whitespace
      titleEn = titleEn.trim();
      titleAm = titleAm.trim();
      contentEn = contentEn.trim();
      contentAm = contentAm.trim();
      answerEn = answerEn.trim();
      answerAm = answerAm.trim();

      // Make sure we got the required fields
      if (titleEn.isEmpty ||
          titleAm.isEmpty ||
          contentEn.isEmpty ||
          contentAm.isEmpty) {
        return null;
      }

      // For riddles, make sure we have answers
      if (type == StoryType.riddle && (answerEn.isEmpty || answerAm.isEmpty)) {
        return null;
      }

      return Story(
        titleEn: titleEn,
        titleAm: titleAm,
        contentEn: contentEn,
        contentAm: contentAm,
        type: type,
        topic: topic,
        answerEn: type == StoryType.riddle ? answerEn : null,
        answerAm: type == StoryType.riddle ? answerAm : null,
        dateCreated: DateTime.now(),
        category: _getCategoryFromTopic(topic, type),
        hasBeenViewed: false,
      );
    } catch (e) {
      return null;
    }
  }

  StoryCategory _getCategoryFromTopic(String topic, StoryType type) {
    // Convert topic to lowercase for case-insensitive matching
    final lowercaseTopic = topic.toLowerCase();

    // For stories
    if (type == StoryType.fairyTale) {
      if (_containsAny(lowercaseTopic,
          ['animal', 'lion', 'elephant', 'monkey', 'bird', 'pet'])) {
        return StoryCategory.animals;
      } else if (_containsAny(lowercaseTopic, [
        'nature',
        'forest',
        'mountain',
        'river',
        'ocean',
        'plant',
        'flower',
        'tree'
      ])) {
        return StoryCategory.nature;
      } else if (_containsAny(lowercaseTopic, [
        'culture',
        'tradition',
        'heritage',
        'festival',
        'ceremony',
        'ethiopia',
        'amharic'
      ])) {
        return StoryCategory.culture;
      } else if (_containsAny(lowercaseTopic, [
        'history',
        'past',
        'ancient',
        'king',
        'queen',
        'war',
        'revolution'
      ])) {
        return StoryCategory.history;
      } else if (_containsAny(lowercaseTopic, [
        'family',
        'mother',
        'father',
        'sister',
        'brother',
        'parents',
        'home'
      ])) {
        return StoryCategory.family;
      } else if (_containsAny(lowercaseTopic,
          ['friend', 'friendship', 'together', 'companion', 'relationship'])) {
        return StoryCategory.friendship;
      }
    }
    // For riddles
    else if (type == StoryType.riddle) {
      if (_containsAny(lowercaseTopic, [
        'wisdom',
        'smart',
        'clever',
        'think',
        'brain',
        'puzzle',
        'challenge'
      ])) {
        return StoryCategory.wisdom;
      }
    }

    // Default category
    return StoryCategory.userCreated;
  }

  bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  void removeStory(Story story) {
    _stories.remove(story);
    notifyListeners();
  }
}
