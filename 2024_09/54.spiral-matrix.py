#
# @lc app=leetcode id=54 lang=python
#
# [54] Spiral Matrix
#


# @lc code=start
class Solution(object):
    def spiralOrder(self, matrix):
        """
        :type matrix: List[List[int]]
        :rtype: List[int]
        """
        sol = []
        m, n = len(matrix), len(matrix[0])
        i, j = 0, 0
        while j < n:
            while i < m:
                sol.append(matrix[i][j])
                if j != n - 1:
                    j += 1
                else:
                    break
            sol.append(matrix[i][j])
            if i != n - 1:
                i += 1
            else:
                break
        print(sol)
        return sol


# @lc code=end

matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
x = Solution()
x.spiralOrder(matrix)
