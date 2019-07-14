USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncRequestorMaster]    Script Date: 7/11/2019 6:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from  dbo.RequestorMaster

ALTER proc [Sync].[syncRequestorMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	
	select t.* into #temprequestor1 
			from
			(
				select distinct
				ri.Id as _OrigRequestorId
				,ltrim(rtrim(isnull(ri.Requestor,''))) as RequestorName
				,ri.IsActive as ReqIsActive
				,isnull(ri.reqId,0) as ReqReqId
				,getdate() as CreateTs
				,getdate() as UpdateTs
				from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
				where ri.Requestor not in(' ','','.','-','**','self','*')
				
				and ri.Issync = 0

				
				union
				select top 1
				ri.Id as _OrigRequestorId
				,isnull(ri.Requestor,'') as RequestorName
				,ri.IsActive as ReqIsActive
				,isnull(ri.reqId,0) as ReqReqId
				,getdate() as CreateTs
				,getdate() as UpdateTs
				from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
				where ri.Requestor='.' 
				and ri.Issync = 0

				union
				select top 1
				ri.Id as _OrigRequestorId
				,isnull(ri.Requestor,'') as RequestorName
				,ri.IsActive as ReqIsActive
				,isnull(ri.reqId,0) as ReqReqId
				,getdate() as CreateTs
				,getdate() as UpdateTs
				from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
				where ri.Requestor='-' 
				and ri.Issync = 0

				union
				select top 1
				ri.Id as _OrigRequestorId
				,isnull(ri.Requestor,'') as RequestorName
				,ri.IsActive as ReqIsActive
				,isnull(ri.reqId,0) as ReqReqId
				,getdate() as CreateTs
				,getdate() as UpdateTs
				from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
				where ri.Requestor='**' 
				and ri.Issync = 0

			--	union
			--	select distinct
			--	ri.Id as _OrigRequestorId
			--	,isnull(ri.Requestor,'') as RequestorName
			--	,ri.IsActive as ReqIsActive
			--	,isnull(ri.reqId,0) as ReqReqId
			--	,getdate() as CreateTs
			--	,getdate() as UpdateTs
			--	from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
			--	where ri.Id = ' '
			--	and ri.Issync = 0

				union
				select top 1
				ri.Id as _OrigRequestorId
				,isnull(ri.Requestor,'') as RequestorName
				,ri.IsActive as ReqIsActive
				,isnull(ri.reqId,0) as ReqReqId
				,getdate() as CreateTs
				,getdate() as UpdateTs
				from NRLBAN.Carelab_Ktm_104.dbo.tbl_RequestorInfo ri
				where ri.Requestor='*' 
				and ri.Issync = 0
			) as t
			order by t._OrigRequestorId
			
	Merge dbo.RequestorMaster as target
	using (
			select * from #temprequestor1
	) as source
	on target._OrigRequestorId = source._OrigRequestorId
	and target.fiscalyear = @fiscalyear
	when matched and 
	(
		target.RequestorName <> source.RequestorName 
		or target.ReqIsActive <> source.ReqIsActive 
		or target.ReqReqId <> source.ReqReqId 
	)
	then
	update set RequestorName = source.RequestorName, 
	ReqIsActive = source.ReqIsActive,
	ReqReqId = source.ReqReqId,
	Issync = 0

	when not matched then
	insert (_OrigRequestorId,RequestorName,ReqIsActive,ReqReqId,CreateTs,UpdateTs,fiscalyear)
	values(source._OrigRequestorId,source.RequestorName,source.ReqIsActive,source.ReqReqId,getdate(),getdate(),@fiscalyear);
end

