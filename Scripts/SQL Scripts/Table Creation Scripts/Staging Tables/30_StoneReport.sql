USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[StoneReport]    Script Date: 7/8/2019 3:17:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StoneReport](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_OrigPatId] [int] NULL,
	[_OrigTestId] [int] NULL,
	[_OrigSubTestId] [int] NULL,
	[TestSubType] [nvarchar](300) NULL,
	[Result] [nvarchar](max) NULL,
	[Group] [nvarchar](100) NULL,
	[Range] [nvarchar](max) NULL,
	[Method] [nvarchar](max) NULL,
	[_OrigResultId] [int] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[AcutalPatId] [int] NULL,
	[IsSync] [bit] NULL,
	[RecordId] [int] NULL,
	[IsReportDone] [bit] NULL,
	[IsReportTaken] [bit] NULL,
	[SpecialistId] [int] NULL,
	[ResultDate] [varchar](100) NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[StoneReport] ADD  DEFAULT ((0)) FOR [IsSync]
GO