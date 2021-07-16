import QtQuick 2.15

Item {
    property alias melistmodel: listview.model
    property alias outlistmodel: outmodel
    property alias listvieww: listview.width

    property alias image_tishi_visible: image_tishi.visible
    property alias timer_tishi: timer
    property int out: 0


//以下是接口函数..............................................................
    // 读入自己排序好的手牌
    function read_hand_card(){
        var nums= client.getHandPool()
        var nums_copy = new Array(nums.length)
        var nums_head = new Array
        var nums_head_2 = new Array
        var nums_k = new Array
        var nums_kings = new Array
        for (var p=0; p<nums.length; p++) {
            if ((nums[p] === 1)) {
                nums_head.push(nums[p])
                nums.splice(p, 1)
                p--
            }

            if (nums[p] === 53 || nums[p] === 54) {
                nums_kings.push(nums[p])
                nums.splice(p, 1)
                p--
            } else if ((nums[p] % 13) === 0) {
                nums_k.push(nums[p])
                nums.splice(p, 1)
                p--
            } else if ((nums[p] % 13) === 1) {
                nums_head.push(nums[p])
                nums.splice(p, 1)
                p--
            } else if ((nums[p] % 13) === 2) {
                nums_head_2.push(nums[p])
                nums.splice(p, 1)
                p--
            }
        }
        for (var q=0; q<nums.length; q++) {
            nums_copy[q] = ((parseFloat(nums[q] % 13)) + (parseFloat(nums[q] / 130)))
        }
        var len = nums.length;
        for (var i = 0; i < len-1; i++) {
            for (var j = 0; j < len - 1 - i; j++) {
                if (nums_copy[j] < nums_copy[j + 1]) {
                    var temp_1 = nums[j];
                    nums[j] = nums[j+1];
                    nums[j+1] = temp_1;
                    var temp_2 = nums_copy[j];
                    nums_copy[j] = nums_copy[j+1];
                    nums_copy[j+1] = temp_2;
                }
            }
        }
        // nums_copy = nums_copy.sort(function sortMaxMin(a, b){return b-a})
        listmodel.clear()
        nums_k.push.apply(nums_k,nums)
        nums_head.push.apply(nums_head, nums_k)
        nums_head_2.push.apply(nums_head_2,nums_head)
        nums_kings.push.apply(nums_kings, nums_head_2)
       // nums.push.apply(nums_k, nums)
//        nums.push.apply(nums, nums_head)
//        nums.push.apply(nums, nums_head_2)
//        nums.push.apply(nums, nums_kings)s
        for(var k=0;k<nums_kings.length;k++) {
            listmodel.append({"mark":nums_kings[k]})
        }
        listview.model=listmodel
    }
    // 读取想要出的牌
    function find_card(){
        var nums=[]
        for(var i=0;i<listview.model.count;i++){
            if(listview.itemAtIndex(i).imagestate==="out"){
                nums.push(listview.model.get(i).mark)
            }
        }

        client.setOutCard(nums);
        client.setSelfRound(nums);
    }
    // 手牌删除出的牌，出牌区显示
    function deletecard(){
        var nums=[]
        var lastmodel=0
        for(var i=0;i<listview.model.count;i++){
            if(listview.itemAtIndex(i).imagestate==="out"){
                nums.push(i)
            }else{//找出最后一张不出的牌
                lastmodel=i
            }
        }
        listview.itemAtIndex(lastmodel).mymousearea.width=123//将出牌后的最后一张不出的牌变成整张的mousearea
        var n=0
        outlistmodel.clear()
        for(var j=0;j<nums.length;j++){
            outlistmodel.append(listview.model.get(nums[j]-n))
            listview.model.remove(nums[j]-n)
            n++
        }
    }
    //读取自己手牌
    function outing_card(){
        var nums=[]
        for(var i=0;i<listview.model.length;i++){
            nums[i]=listview.model.get(i).mark
        }
        client.setHandPool(nums);
    }

//...........................................................................
    function recycle(){//放回牌
        for(var i=0;i<listview.model.count;i++){
            listview.itemAtIndex(i).imagestate="in"
        }
    }
    ListModel{//保存自己手牌的listmodel
        id:listmodel
    }

    ListModel{//出牌区域的listmodel
        id:outmodel
    }
    Image {
        id: image_tishi
        width: 240
        height: 32
        z:1
        visible: false
        anchors.centerIn: parent
        source: "../../assets/img/Game/frame_illegality.png"
    }
    Timer{
        id:timer
        interval: 1000
        running: false
        onTriggered:image_tishi.visible=false
    }


//显示自己手牌的listview....................................................
    ListView{
        id:listview
        width: 123
        height: 170
        anchors.centerIn: parent//使它居中
        ListView.delayRemove:false
        model:listmodel
        delegate:
            Card{
            Component.onCompleted: {
                changepai(mark)//改变牌值
                if(index===listview.model.count-1){
                    mymousearea.width=123//最后一张牌 需要覆盖满mousearea
                }
            }
        }
        spacing: -82//使它重叠
        orientation: ListView.Horizontal//让它水平
        interactive:false//让它不能滑动
    }
}
