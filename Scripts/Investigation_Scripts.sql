USE [Stag_Carelab_Ban]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [NonClusteredIndex-20190623-000303]    Script Date: 6/23/2019 12:12:46 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190623-000303] ON [dbo].[DiagnosisMaster]
(
	[_DiagnosisIDOrig] ASC,
	[DiagnosisName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

alter table TestMaster alter column TestCode varchar(max) not null
CREATE NONCLUSTERED INDEX [NonClusteredIndex-IX-TestMaster] ON [dbo].[TestMaster]
(
	[_TestIDOrig] ASC,
	[TestCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO