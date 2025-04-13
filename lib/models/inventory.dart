class Inventory{
  int _coin = 0;
  int _food = 0;
  int _soap = 0;
  int _medicine = 0;

  int getCoin(){
    return _coin;
  }

  int getFood(){
    return _food;
  }

  int getSoap(){
    return _soap;
  }
  int getMedicine(){
    return _medicine;
  }

  void setCoin(int c){
    _coin = c;
  }

  void setFood(int f){
    _food = f;
  }

  void setSoap(int s){
    _soap = s;
  }
  void setMedicine(int m){
    _medicine = m;
  }
}