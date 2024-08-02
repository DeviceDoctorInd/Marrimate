
class Constants{
  Constants._();

  static const int normalLikeLimit = 5;
  static const int normalDaysLimit = 7;

  static const int starterXLikeLimit = 300;
  static const int starterXDaysLimit = 90;

  static const int proLikeLimit = 1000;
  static const int proDaysLimit = 365;

  ///Agora
  static const appId = "b0db29953d2a4ee68566669af4b7ead1";
  static const token = "007eJxTYIg8c8VcJe616z+W/0Jnm+SPCtpG8Ey3a1p/Yeq7ANfDooUKDOamqQYmBsmJaWam5iZGyZYWZibGJqYmpqmpKUlmhikGW59LJptaSieLO5gzMTJAIIjPylCSWlxiyMAAAB9OHjE=";
  static const channel = "test1";

  ///Filters
  static const List<String> ageRange = ['All', '18 - 25', '26 - 35', '36 - 45', '46 - 55', '56 - 65', '66 - 75', '76 - 85', '86 - 95'];
  static const List<String> genders = ['All', 'Man', 'Woman', 'Other'];
  static const List<String> languages = ['English', 'Hindi', 'Chinese', 'Italian', 'Portuguese', 'Korean', 'French'];

  static int getLikeLimit(int planID){
    if(planID == 1){
      return normalLikeLimit;
    }
    if(planID == 2){
      return starterXLikeLimit;
    }
    if(planID == 3){
      return proLikeLimit;
    }
  }
  static int getDaysLimit(int planID){
    if(planID == 1){
      return normalDaysLimit;
    }
    if(planID == 2){
      return starterXDaysLimit;
    }
    if(planID == 3){
      return proDaysLimit;
    }
  }

}