USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[DiagnosisMaster]    Script Date: 6/22/2019 11:49:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DiagnosisMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_DiagnosisIDOrig] [varchar](255) NULL,
	[DiagnosisName] [varchar](255) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DiagnosisMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO

ALTER TABLE [dbo].[DiagnosisMaster] ADD [fiscalyear] varchar(10) not null
GO
