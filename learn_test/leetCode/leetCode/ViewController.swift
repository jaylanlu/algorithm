//
//  ViewController.swift
//  leetCode
//
//  Created by Jaylan on 2019/1/16.
//  Copyright © 2019 Jaylan. All rights reserved.
//

import UIKit

class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var arr = twoSum([3,3], 6);

//        let l1 = createList(243)
//        let l2 = createList(564)
//        printList(l1)
//        printList(l2)
//        addTwoNumbers(l1?.next, l2?.next)
        
//        lengthOfLongestSubstring("tmmzuxt")
//        findMedianSortedArrays([1,3], [2])
        longestPalindrome("aa")
    }
    
    //头插法
    func createList(_ target: Int) -> ListNode? {
        if target < 0 {
            return nil;
        }
        if target == 0 {
            return ListNode.init(target);
        }
        var num = target
        let head = ListNode.init(0);
        while num != 0 {
            let node = ListNode.init(num % 10)
            node.next = head.next;
            head.next = node;
            num /= 10
        }
        return head
    }
    
    //尾插法
    func listInit(_ target: Int) -> ListNode? {
        if target < 0 {
            return nil;
        }
        if target == 0 {
            return ListNode.init(target);
        }
        var num = target
        let head = ListNode.init(0);
        var p = head
        while num != 0 {
            while p.next != nil {
                p = p.next!
            }
            let node = ListNode.init(num % 10)
            p.next = node
            num /= 10
        }
        return head.next
    }
    
    func printList(_ list: ListNode?) {
        var l = list
        while l?.next != nil {
            print("\(l!.val)->", terminator: "")
            l = l?.next
        }
        print("\(String(describing: l!.val))")
    }
    
    ///1
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        /*方法二优化*/
        var dict = [Int: Int]();
        for (idx, num) in nums.enumerated() {
            if let lastIndex = dict[target-num]{
                return [lastIndex, idx];
            }
            dict[num] = idx;
        }
        
        return [0];
        
        
        /*方法二
         var dict = [Int: Int]();
         for (idx, num) in nums.enumerated() {
         dict[num] = idx;
         }
         for (idx, num) in nums.enumerated() {
         if let lastIndex = dict[target-num], lastIndex != idx {
         return [idx, lastIndex];
         }
         }
         
         return [0];
         */
        
        
        /*方法1 
         var idx0: Int?;
         var idx1: Int?;
         for idx in 0 ... nums.count - 1 {
         var arr = nums;
         arr.remove(at: idx);
         if arr.contains(target - nums[idx]) {
         idx0 = idx;
         break;
         }
         }
         
         for idx in 0 ... nums.count - 1 {
         if nums[idx] == target - nums[idx0 ?? 0] && idx0 != idx {
         idx1 = idx;
         break;
         }
         }
         return [idx0 ?? 0, idx1 ?? 0];
         
         }
         */
        
    }
    ///2
        func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
            var list1 = l1
            var list2 = l2
            var list: ListNode?
            var p: ListNode?
            var ll = 0
            while list1 != nil || list2 != nil {
                var sum = (list1 != nil ? list1!.val : 0) + (list2 != nil ? list2!.val : 0)  + ll
                if sum > 9 {
                    ll = sum/10
                    sum = sum % 10
                }else {
                    ll = 0
                }
                let node = ListNode.init(sum)
                if list == nil {
                    list = ListNode.init(sum);
                    p = list;
                }else {
                    p?.next = node;
                    p = node;
                }
                list1 = list1?.next
                list2 = list2?.next
                
            }
            if ll > 0 {
                let node = ListNode(ll)
                p?.next = node
            }
            return list
        }
    ///3
    func lengthOfLongestSubstring(_ s: String) -> Int {

//        let arr = Array.init(s)
//        if arr.count <= 1 {
//            return s.count
//        }
//        var i = 0, j = 1
//        var maxlength = 0
//        while i < arr.count - 1 {
//            j = i + 1
//            while j < arr.count {
//                if isAllUniqueString(s, start: i, end: j){
//                  maxlength =  max(maxlength, j - i)
//                }
//                j += 1
//            }
//            i += 1
//        }
//        return maxlength + 1
/*滑动窗口
        let arr = Array.init(s)
        if arr.count <= 1 {
            return arr.count
        }
        var chSet = Set<Character>()
        var i = 0
        var j = 0
        var maxLength = 0
        while i < arr.count && j < arr.count {
            if !chSet.contains(arr[j]) {
                chSet.insert(arr[j])
                maxLength = max(maxLength, j - i)
                j += 1
            }else {
                chSet.remove(arr[i])
                i = j
            }
        }
        return maxLength + 1

 */
        let arr = Array.init(s)
        if arr.count <= 1 {
            return arr.count
        }
        var dict = [Character: Int]()
        var i = 0
        var j = 0
        var maxLength = 0
        while i < arr.count && j < arr.count {
            if !dict.keys.contains(arr[j]) {
                dict[arr[j]] = j
                maxLength = max(maxLength, j - i)
                j += 1
            }else if let left = dict[arr[j]] {
                if left < i {
                    dict[arr[j]] = j
                    maxLength = max(maxLength, j - i)
                    j += 1
                }else {
                    dict[arr[j]] = j
                    i = left + 1
                    j += 1
                }
                
            }
        }
        return maxLength + 1

        
    }
    
    func isAllUniqueString(_ s: String, start: Int, end: Int) -> Bool {
        let arr = Array.init(s)
        var strSet = Set<Character>()
        for idx in start ... end {
            let ch: Character = arr[idx]
            if strSet.contains(ch) {
                return false
            }else {
                strSet.insert(arr[idx])
            }
        }
        return true
    }
    
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        
        var len1 = nums1.count
        var len2 = nums2.count
        var arr1 = nums1
        var arr2 = nums2
        if len1 > len2 {
            len1 = len1 + len2
            len2 = len1 - len2
            len1 = len1 - len2
            let temp = arr2
            arr2 = arr1
            arr1 = temp
            /*
            len1 = len1 ^ len2
            len2 = len1 ^ len2
            len1 = len1 ^ len2*/
        }
        let half = (len2 + len1+1)/2
        var iMin = 0
        var iMax = len1
        while iMin <= iMax {
            let i = (iMin + iMax)/2
            let j = half - i
            if i < iMax && arr2[j-1] > arr1[i]  {
                iMax = i + 1
            }else if i > iMin && arr1[i-1] > arr2[j] {
                iMin = i - 1
            }
            else {
                var maxLeft = 0
                var minRight = 0
                if(i == 0) {
                    maxLeft = arr2[j-1]
                }else if(j == 0) {
                    maxLeft = arr1[i-1]
                }else {
                    maxLeft = max(arr1[i-1], arr2[j-1])
                }
                if((len2 + len1)%2 == 1) {
                    return Double(maxLeft)/1.0
                }
                if(i == len1) {
                    minRight = arr2[j]
                }else if (j == len2) {
                    minRight = arr1[i]
                }else {
                    minRight = min(arr1[i], arr2[i])
                }
                return Double((maxLeft + minRight))/2.0
                
            }
        }
        return 0.0
        
        
        
        /*有序二路归并排序（归并排序的一次排序）
        let length = nums1.count + nums2.count
        var nums = Array.init(repeating: 0, count: length)
        var i = 0
        var j = 0
        var k = 0
        while i < nums1.count && j < nums2.count {
            if nums1[i] < nums2[j] {
                nums[k] = nums1[i]
                i += 1
            }else {
                nums[k] = nums2[j]
                j += 1
            }
            k += 1
        }
        while i < nums1.count {
            nums[k] = nums1[i]
            i += 1
            k += 1
        }
        while j < nums2.count {
            nums[k] = nums2[j]
            j += 1
            k += 1
        }
        if length % 2 == 0 {
            return Double((nums[length/2 - 1] + nums[length/2]))/2.0
        }else {
            return Double((nums[length/2]))/1.0
        }*/
    }
    
    func longestPalindrome(_ s: String) -> String {
        //反转字符串
        let arr = Array.init(s)
        var arr1 = Array<Character>()
        var i = arr.count - 1
        while i >= 0 {
            arr1.append(arr[i])
            i -= 1
        }
        
        //求最大公共子串，矩阵
        var arrData = [[Int]]()
        var h = 0
        var k = 0
        var tab = (0, 0)
        while h < arr.count {
            var b =
            while k < arr.count {
                arrData[h][k] = 0
                if arr[h] == arr1[k] {
                    if !h == 0 || k == 0 {
                        arrData[h][k] = arrData[h-1][k-1] + 1
                    }
                    if arrData[h][k] > tab.1 {
                        tab = (h, arrData[h][k])
                    }
                }else {
                    arrData[h][k] = 0
                }
                k += 1
            }
            h += 1
        }
        if isPalindRome(s, tab.0 - tab.1 - 1, tab.0 - 1) {
            var ss = Array<Character>()
            var k = tab.0 - tab.1 - 1
            while k <= tab.1 {
                ss.append(arr[k])
                k += 1
            }
            return String(ss)
        }else {
            return s
        }
        
       /*暴力法
         let arr = Array.init(s)
        if arr.count == 0 {
            return ""
        }
        if arr.count == 1 {
            return s
        }
        var i = 0
        var maxArr = [(Int, Int)]()
        while i < arr.count - 1 {
            var j = i
            while j <= arr.count - 1 {
                if isPalindRome(s, i, j) {
                    maxArr.append((i,j))
                }
                j += 1
            }
            i += 1
        }
        var maxlen = 0
        var index = 0
        for (idx, item) in maxArr.enumerated() {
            if item.1 - item.0 > maxlen {
                maxlen = item.1 - item.0
                index = idx
            }
        }
        var k = maxArr[index].0
        var ss = Array<Character>()
        while k <= maxArr[index].1 {
            ss.append(arr[k])
            k += 1
        }
        return String(ss)
        */
    }
    
    func isPalindRome(_ s: String, _ i: Int, _ j: Int) -> Bool {
        let arr = Array.init(s)
        var h = i
        var k = j
        while h <= k {
            if !(arr[h] == arr[k]) {
                return false
            }
            h += 1
            k -= 1
        }
        return true
    }
    
}

