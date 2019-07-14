USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncMolecularBiologyLookUp]    Script Date: 6/24/2019 1:42:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from  dbo.tbl_MolecularBiologyLookUp

ALTER proc [Sync].[syncMolecularBiologyLookUp]
as
begin
				
			
	Merge dbo.tbl_MolecularBiologyLookUp as target
	using (
			SELECT 
				 MBL.Id			AS LocalID
				,MBL.GroupName
				,MBL.Note
				,MBL.Technology
				,MBL.PathogenInfo
				,MBL.Method
				,MBL.ReferenceResult
				,MBL.Comments
				,MBL.Interpretation
				,MBL.Description
				,MBL.SampleType
				,GETDATE() as CreateTs
				,GETDATE() as UpdateTs
				FROM NRLBAN.Carelab_Ktm_104.[dbo].[tbl_MolecularBiologyLookUp] MBL
				where 1=1
				--AND MBL.Issync = 0
	) as source
	on target.ID = source.LocalID
	when matched 
	then
	UPDATE SET	 --target.Id              = source.Id
				 target.GroupName       = source.GroupName
				,target.Note            = source.Note
				,target.Technology      = source.Technology
				,target.PathogenInfo    = source.PathogenInfo
				,target.Method          = source.Method
				,target.ReferenceResult = source.ReferenceResult
				,target.Comments        = source.Comments
				,target.Interpretation  = source.Interpretation
				,target.Description     = source.Description
				,target.SampleType      = source.SampleType
				,Target.Issync = 0

	when not matched then
	insert (  LocalId             
			 ,GroupName      
			 ,Note           
			 ,Technology     
			 ,PathogenInfo   
			 ,Method         
			 ,ReferenceResult
			 ,Comments       
			 ,Interpretation 
			 ,Description    
			 ,SampleType     
			)
		VALUES
		(
		  source.LocalId
		 ,source.GroupName
		 ,source.Note
		 ,source.Technology
		 ,source.PathogenInfo
		 ,source.Method
		 ,source.ReferenceResult
		 ,source.Comments
		 ,source.Interpretation
		 ,source.Description
		 ,source.SampleType
		 );
end

