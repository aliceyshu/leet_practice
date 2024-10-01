--
-- @lc app=leetcode id=180 lang=mysql
--
-- [180] Consecutive Numbers
--

-- @lc code=start
# Write your MySQL query statement below

with consecutiveNums AS (
    select num as ConsecutiveNums
    from Logs
    where (Id+1, Num) in (select * from Logs) 
        and (Id-1, Num) in (select * from Logs)
        and (Id, Num) in (select * from Logs)
    )

SELECT DISTINCT ConsecutiveNums
FROM consecutiveNums;

-- @lc code=end

/*
Comment
代码的优缺点
1.优点：
简单直接：查询逻辑相对直接，通过自联接找到连续三次出现相同 Num 的记录，并使用窗口函数或
自联接的方式来实现。
可读性好：这个查询的每一步逻辑清晰易懂，对于面试官来说是比较容易理解的代码。
2.缺点：
性能问题：这个查询的主要问题在于性能。WHERE 子句包含多个子查询，每个子查询的时间复杂度
为 O(n)，所以总复杂度为 O(n^3)，对于大规模数据集来说，性能可能会很差。这在面试中可能
会成为一个瓶颈，尤其是如果面试官追问优化方案时。
不必要的计算：实际上，WHERE (Id, Num) IN (SELECT * FROM Logs) 是不必要的，因为 
(Id, Num) 一定是在原始表中的。这会导致额外的性能开销。


面试表现评估
基本能力展示：你的解决方案展示了你对 SQL 的基本掌握，特别是你能够构建递归查询来解决
问题，并利用 WITH 子句组织查询逻辑。
优化讨论：面试官可能会关注性能问题，因为 O(n^3) 的复杂度对于大数据集是不现实的。
在这种情况下，你需要展示你能够识别性能瓶颈，并提出优化方案。
代码质量：尽管代码清晰，但其性能问题可能会成为面试中的扣分点。尤其是对于大数据量来说，
查询的时间复杂度非常高，不具备良好的扩展性。


优化方案
考虑到性能问题，我们可以通过避免重复查询、减少不必要的子查询和使用更高效的方法来优化
查询。以下是几种改进的方向：
1. 自联接方法 (Self Join)
2. 使用窗口函数 (Window Function)
3. GROUP BY 和 HAVING 计数法
*/
