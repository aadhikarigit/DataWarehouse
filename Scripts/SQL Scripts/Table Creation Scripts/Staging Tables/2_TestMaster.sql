USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[TestMaster]    Script Date: 7/8/2019 3:18:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TestMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_TestIDOrig] [varchar](max) NOT NULL,
	[TestCode] [varchar](max) NOT NULL,
	[Testname] [varchar](max) NULL,
	[Price] [varchar](max) NULL,
	[TotalPrice] [varchar](max) NULL,
	[Specimen] [varchar](max) NULL,
	[Method] [varchar](max) NULL,
	[Schedule] [varchar](max) NULL,
	[Reporting] [varchar](max) NULL,
	[Units] [varchar](max) NULL,
	[IsOutGoingTest] [varchar](max) NULL,
	[SubGroupId] [varchar](max) NULL,
	[SubGroupType] [varchar](max) NULL,
	[IsCulture] [varchar](max) NULL,
	[EnteredBy] [varchar](max) NULL,
	[EntryDate] [varchar](max) NULL,
	[TestIsActive] [varchar](max) NULL,
	[TestType] [varchar](max) NULL,
	[IsHisto] [varchar](max) NULL,
	[IsDifferentialTest] [varchar](max) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO