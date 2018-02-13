CREATE TABLE Clients
(
	 ID INT identity(1,1)
	,Code varchar(10)
	,CName	VARCHAR(50)
	,CLocation VARCHAR(100)
	,CreateTs	DATETIME
	,UpdateTs	DATETIME
)
insert into Clients

 select
 branchID as Code
,branchName as CName
,'Kathmandu' as CLocation
,getdate() as CreateTs
,getdate() as UpdateTs
from  Carelab_Ktm_Current.[branch].[tbl_BranchInfo]

select * from Clients