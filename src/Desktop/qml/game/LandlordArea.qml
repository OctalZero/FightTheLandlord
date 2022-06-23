import QtQuick 2.15

Item {
    property alias landlordareamodel: listview.model//将存储牌的model显示在外面使用

    //将牌从背面显示到正面
    function changeCardstate(){
        for(var i=0;i<listview.model.count;i++){
            listview.itemAtIndex(i).state="front"
        }
    }

    ListModel{
        id:listmodel
        ListElement{
            mark:"1"
        }
        ListElement{
            mark:"1"
        }
        ListElement{
            mark:"1"
        }
    }

    ListView{//显示地主牌的listview
        id:listview
        width: 200
        height: 90
        orientation: ListView.Horizontal//让它水平显示
        interactive:false//让它不能滑动
        model:listmodel

        delegate: CardIntial{
            state: "back"//首先显示背面
            Component.onCompleted: {
                changepai(mark)//改变牌的图片
            }
        }
    }
}
