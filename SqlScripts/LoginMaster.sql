INSERT INTO  DataWareHouse..LoginMaster

SELECT 
  'MEMBER' AS LoginType
, MemberCode AS LoginTypeID
, MemberCode+ 'LOG' AS LoginID
, MemberCode + 'pwd' AS LoginPw
, getdate() AS CreateTs
, getdate() AS UpdateTS
, 1 AS IsActive
FROM DataWareHouse.[dbo].[MemberMaster]