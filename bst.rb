class Node
    attr_accessor :left, :right, :value
    def initialize(value)
        @left = nil
        @right = nil
        @value = value
    end
end

class Tree
    attr_accessor :root

    def initialize(arr)
        @arr = arr.sort.uniq
        last = arr.size - 1
        @root = build_tree(arr, 0, last)
    end 

    def build_tree(arr, start, end_index)
        if (start > end_index)
            return nil
        end
        mid = (start+end_index)/2
        root = Node.new(arr[mid])
        root.left = build_tree(arr, start, mid-1)
        root.right = build_tree(arr, mid+1, end_index)
        return root
    end

    def insert(value, node=@root)

        if value < node.value
            while !node.left.nil?
                node = node.left
            end
            node.left = Node.new(value)
        elsif value > node.value
            while !node.right.nil?
                node = node.right
            end
            node.right = Node.new(value)
        end
    end

    def delete(value, node=@root)
        #case 1, removing leaf node
        #case 2, removing node with 1 child -> point node's parent to node's child
        #case 3, remove value that has children ->reduce it to case 2 and 1
        # find min value on right subtree, replace node with min value, remove duplicate on right subtree
        if node.nil?
            return nil 
        elsif value < node.value #loop leftsubtree
            node.left = delete(value, node.left)
        elsif value > node.value #loop rightsubtree
            node.right = delete(value, node.right)
        else #found target
            if node.left.nil? && node.right.nil? #delete leaf node
                node = nil
            elsif node.left.nil? #delete node with 1 child on left subtree
                temp = node
                node = node.right
                temp = nil
            elsif node.right.nil? #delete node with 1 child on left subtree
                temp = node
                node = node.left
                temp = nil
            else #delete node with 2 children, use min value in rightsubtree
                temp = node.right
                node.value = temp.value
                node.right = delete(temp.value,node.right)
            end
        end
        return node
    end

    def find(value, node=@root)
        #return node and all its children 
        if node.nil?
            return nil 
        elsif value < node.value
            find(value, node.left)
        elsif value > node.value
            find(value, node.right)
        else
            return node.value
        end
    end
#bfs traversal
    def level_order(node=@root, q=[]) 
        return node if node.nil?
        print "#{node.value} "
        if !node.left.nil?
            q.push(node.left)
        end
        if !node.right.nil?
            q.push(node.right)
        end
        level_order(q.shift, q)
    end
#dfs traversal : 3ways
#1) Preorder <root><left><right> 
#2) Inorder <left><root><right> 
#3) Postorder <left><right><root>

    def preorder(node=@root)
        return if node.nil?
        print"#{node.value} "
        preorder(node.left)
        preorder(node.right)
    end

    def inorder(node=@root)
        return if node.nil?
        preorder(node.left)
        print"#{node.value} "
        preorder(node.right)
    end

    def postorder(node=@root)
        return if node.nil?
        preorder(node.left)
        preorder(node.right)
        print"#{node.value} "
    end

    def height(node=@root)
        return -1 if node.nil?
        left = height(node.left)
        right = height(node.right)
        [left,right].max + 1
    end

    def depth(node, parent=@root, current_depth = 0)
        return current_depth if node == parent 
        if parent.left!=node
            depth(node, parent.right, current_depth+1)
        elsif parent.right!=node
            depth(node, parent.left, current_depth+1)
        end
    end

    def balanced?(node=@root)
        left = height(node.left)
        right = height(node.right)
        if (left-right).abs > 1
            puts "Unbalanced"
            return false
        else
            puts "Balanced"
            return true
        end
    end

    def inorder_arr(node=@root, arr=[])
        return arr if node.nil?
        inorder_arr(node.left, arr)
        arr.push(node.value)
        inorder_arr(node.right, arr)
    end

    def rebalance
        arr = inorder_arr
        last_index = (arr.size) -1
        @root = build_tree(arr, 0, last_index)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
end


arr = [1,2,3,4,5,6,7]

tree = Tree.new(arr)
#     4            2
#  2     6         1
#1   3 5   7       0

tree.insert(8)
tree.insert(9)
tree.insert(10)

tree.rebalance
tree.pretty_print

