//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
    }
    
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var list1: ListNode? = l1;
        var list2: ListNode? = l2;
        var sum: Int = 0;
        while list1 != nil {
            sum *= 10
            sum += list1!.val + list2!.val
            list1 = list1!.next!;
            list2 = list2!.next!;
        }
        var head = ListNode.init(0);
        while sum != 0 {
            let node = ListNode.init(sum % 10)
            node.next = head.next;
            head = node;
            sum /= 10;
        }
        return head
    }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

