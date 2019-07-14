USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncQuadrupleLookUp]    Script Date: 6/24/2019 1:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from  dbo.tbl_QuadrupleLookUp

ALTER proc [Sync].[syncQuadrupleLookUp]
as
begin
				
			
	Merge dbo.tbl_QuadrupleLookUp as target
	using (
			SELECT 
				 QDL.Id		AS LocalId
				,QDL.GroupName
				,QDL.Remarks_main
				,QDL.Interpretation
				,QDL.Disorder
				,QDL.[Screen_+veCutoff]
				,QDL.Remarks
				,QDL.Method
				,QDL.SampleType
				,GETDATE() as CreateTs
				,GETDATE() as UpdateTs
				FROM NRLBAN.Carelab_Ktm_104.[dbo].[tbl_QuadrupleLookUp] QDL
				where 1=1
				--AND QDL.Issync = 0
	) as source
	on target.ID = source.LocalID
	when matched 
	then
	UPDATE SET	  --TARGET.Id               	= SOURCE.Id
				  TARGET.GroupName        	= SOURCE.GroupName
				 ,TARGET.Remarks_main     	= SOURCE.Remarks_main
				 ,TARGET.Interpretation   	= SOURCE.Interpretation
				 ,TARGET.Disorder         	= SOURCE.Disorder
				 ,TARGET.[Screen_+veCutoff] = SOURCE.[Screen_+veCutoff]
				 ,TARGET.Remarks          	= SOURCE.Remarks
				 ,TARGET.Method           	= SOURCE.Method
				 ,TARGET.SampleType       	= SOURCE.SampleType
				 ,TARGET.Issync = 0

	when not matched then
	insert (  
			  LocalId               	
			 ,GroupName        	
			 ,Remarks_main     	
			 ,Interpretation   	
			 ,Disorder         	
			 ,[Screen_+veCutoff]
			 ,Remarks          	
			 ,Method           	
			 ,SampleType
			 ,UpdateTs
			 ,CreateTs
			 ,Issync
			 
			 )
			 values
			 (       	
			 SOURCE.localId
			,SOURCE.GroupName
			,SOURCE.Remarks_main
			,SOURCE.Interpretation
			,SOURCE.Disorder
			,SOURCE.[Screen_+veCutoff]
			,SOURCE.Remarks
			,SOURCE.Method
			,SOURCE.SampleType
			,GETDATE()
			,GETDATE()
			,0
		 );
end

