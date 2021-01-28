import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

//The lists will be defined from the DB later on/ Currently its hard coded
List<String> _mainPicture = [ "assets/Images/antorium.jpg", "assets/Images/antorya.jpg", "assets/Images/big_kikos.jpg", "assets/Images/bonsai.jpg", "assets/Images/dekel.jpg", "assets/Images/difen.jpg", "assets/Images/flower.jpg",
  "assets/Images/kak_three.jpg", "assets/Images/kaktus.jpg", "assets/Images/kikos.jpg", "assets/Images/rakefet.jpg" ];

List<String> _dragPicture = [ "assets/Images/antorium_drag.png", "assets/Images/antorya_drag.png", "assets/Images/big_kikos_drag.png", "assets/Images/bonsai_drag.png", "assets/Images/dekel_drag.png",
  "assets/Images/difen_drag.png", "assets/Images/flower_drag.png", "assets/Images/kak_three_drag.png", "assets/Images/kaktus_drag.png", "assets/Images/kikos_drag.png",
  "assets/Images/rakefet_drag.png"];
final double _imageWidth = 70.0;
final double _imageHeight = 80.0;

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
List<int> picsInRoom = [];
//final List<String> _picNames = [];

class MyHomePage extends StatelessWidget {

  void setOrientation(DeviceOrientation up, DeviceOrientation down)  {
    SystemChrome.setPreferredOrientations([down,up,]);
  }

  @override
  Widget build(BuildContext context) {
    setOrientation(DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: getAppBar(),
        body: Row(
            children:[
              SelectPlantsList(),
              RoomView(),
            ]
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFefffed),
        title: const Text(
          'Room Decoration',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        bottomOpacity: 0.0,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.article, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
            tooltip: 'Take a picture',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder, color: Colors.black),
            tooltip: 'Go to the next page',
            onPressed: () {},
          ),
        ]);
  }


}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Expanded( flex:8,
        child: Text('Hello, World!', style: Theme.of(context).textTheme.headline4),);
  }
}

class SelectPlantsList extends StatefulWidget {
  const SelectPlantsList({ Key key }) : super(key: key);

  @override
  _SelectPlantsListState createState() => _SelectPlantsListState();
}

class _SelectPlantsListState extends State<SelectPlantsList> {

  @override
  Widget build(BuildContext context) {
    _fillInPictures();
    return Expanded (
      flex: 2,
      child: ListView.builder(
        itemBuilder: (BuildContext ctx, int index) {
          return _DraggablePiece(index: index);  },
        itemCount: _mainPicture.length,
      ),
    );
  }


  void _fillInPictures(){
   /* for(int i=10; i<20; i++) {
      final String picNameToAdd = _firstPicUrl + i.toString();
      _picNames.add(picNameToAdd);
    }*/
  }

}


class _PlantsListImageHolder extends StatelessWidget {

  final int index;

  _PlantsListImageHolder({
    Key key, this.index}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100 ,
      width: 100,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.asset(_mainPicture[index], fit: BoxFit.fill),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}

double yPos = 0.0;
double xPos = 0.0;

class _DraggablePiece extends StatelessWidget {
  final int index;
  final VoidCallback onDragStarted;

  _DraggablePiece({
    Key key, this.index, this.onDragStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
        data: index,
        child: _PlantsListImageHolder(index: index),
        feedback: Image.asset(_dragPicture[index], height:20.0, width:20.0,),
        onDragStarted: () { return true; }, //onDragStarted,
        onDragEnd: (details)  {
          yPos = details.offset.dy;
          xPos =  details.offset.dx;
        }
    );
  }
}




class RoomView extends StatefulWidget {
  const RoomView({ Key key }) : super(key: key);

  @override
  _RoomViewState createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  final GlobalKey _dragTargetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: DragTarget<int>(
          key: _dragTargetKey,

          onWillAccept: (int index) {
            return true;
          },
          onAccept: (int index) {
            setState(() {
              picsInRoom.add(index);
            });
            return true;
          },
          builder: (BuildContext context, List<int> candidateData,
              List rejectedData) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.brown,
                    child: Image.asset("assets/Images/room.jpg",)
                  ),
                ),
                ...picsInRoom.map((int index) =>
                    Positioned(
                      left: (xPos),
                      top: (yPos),
                      child: Image.asset(_dragPicture[index],
                        width: 20.0,
                        height: 20.0,),
                    )
                ).toList(),
              ],
            );
          }
      ),
    );
  }
}

class _PlantData extends StatelessWidget {
  int index;
  double xPos;
  double yPos;
  bool onBoard = false;

  _PlantData({
    Key key, this.index, this.xPos, this.yPos, this.onBoard}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if(onBoard == false)   {
      return Image.asset(_mainPicture[index], fit: BoxFit.fill);
    }
    else {
      return Image.asset(_dragPicture[index], height: 30.0, width: 30.0);
    }
  }
}




























/*

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Scaffold(
/*      appBar: AppBar(
        title: Text(),
      ),*/
      body: _MainScreen(),
    );
  }
}

// The entire game UI. Game board and piece inventory.
class _MainScreen extends StatefulWidget {
  _MainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {

  final GlobalKey _dragTargetKey = GlobalKey();
  List<_DroppedImageData> imagesOnTarget;

  void setOrientation(DeviceOrientation up, DeviceOrientation down)  {
    SystemChrome.setPreferredOrientations([down,up,]);
  }

  void _onAddPiece(_DroppedImageData droppedImageData) {
    setState(() {
      print("PIC");
      imagesOnTarget.add(droppedImageData);
    });
  }

  void _onAcceptWithDetails(DragTargetDetails details) {//}, Size size) {
    final RenderBox renderBox = _dragTargetKey.currentContext.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    final Offset offset = Offset(
      localOffset.dx,// / size.width,
      localOffset.dy,// / size.height,
    );
    _onAddPiece(_DroppedImageData(
      offset: offset,
      index: details.data,
    ));
    setOrientation(DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child:  Container(
              color: Color(0xFFefffed),
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: _mainPicture.length,
                itemBuilder: (BuildContext context, int index) {
                  return _columnCard(index);//, _onTapPieceInventory);
                },
                separatorBuilder: (BuildContext context,
                    int index) => const Divider(),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: DragTarget<int>(
              key: _dragTargetKey,
              onWillAccept: (int i) {
                print(i.toString());
                return true;
              },
              onAcceptWithDetails: (DragTargetDetails details) {
                print("On Accept");
                _onAcceptWithDetails(details);
              },
              builder: (BuildContext context, List<int> candidateData, List rejectedData) {
                //final double pieceSide = math.min(_boardSize.width, _boardSize.height) * _kPieceSizeVsBoard;
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.brown,
                        child: Image.asset("assets/Images/room.jpg"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _columnCard(int index) {
    //, _plantTappedCallback plantTapedCallback){
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color(0xFFefffff),
        child: _InventoryPiece(index: index),
      ), //),
    );
  }

  AppBar getAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFefffed),
        title: const Text(
          'Room Decoration',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        bottomOpacity: 0.0,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.article, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
            tooltip: 'Take a picture',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder, color: Colors.black),
            tooltip: 'Go to the next page',
            onPressed: () {},
          ),
        ]);
  }
}

class _InventoryPiece extends StatelessWidget {
  final int index;

  _InventoryPiece({ Key key, @required this.index,}) :  super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(index.toString()); //here we add the pic to the list of pics in room
      },
      child:Draggable(
        child:  Image.asset(_mainPicture[index],
            width: _imageWidth, height: _imageHeight),

        feedback: Image.asset(_dragPicture[index],
            width: (_imageWidth - 20.0), height: (_imageHeight-20.0)),

        childWhenDragging: Image.asset(_mainPicture[index],
            width: _imageWidth, height: _imageHeight),
      ),
    );
  }

}

class _DroppedImageData {
  final int index;
  final Offset offset;

  _DroppedImageData( {Key key,
    @required this.index,
    @required this.offset,
  });
}

*/