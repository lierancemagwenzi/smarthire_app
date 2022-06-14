class CustomerOrderStage{
  int id;
  String stage;
  String text;
  bool hasnext;
  String description;
  String routename;
  String nextstage;
  List<String> nextstages;
  String nextStageButton;


  CustomerOrderStage({this.id, this.stage,this.description,this.routename,this.nextstage,this.nextstages,this.hasnext,this.nextStageButton,this.text});

}