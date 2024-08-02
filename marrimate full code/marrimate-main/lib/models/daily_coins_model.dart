
class DailyCoins{
  List<String> days = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"];
  List<String> coins = ["+50", "+100", "+150", "+200", "+250", "+300", "+350"];
  List<bool> availed = [false, false, false, false, false, false, false];

  DateTime firstDay;

  DailyCoins({this.days, this.coins, this.availed, this.firstDay});

  DailyCoins.fromPreference(List<String> availedCoins, DateTime fDay){
    availed.clear();
    for(var item in availedCoins){
      if(item == "0"){
        availed.add(false);
      }else{
        availed.add(true);
      }
    }
    days = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"];
    coins = ["+50", "+100", "+150", "+200", "+250", "+300", "+350"];
    firstDay = fDay;
  }

}