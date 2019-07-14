USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[PanelMaster]    Script Date: 7/8/2019 3:15:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PanelMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[_OrigPanelId] [int] NULL,
	[PanelName] [varchar](100) NULL,
	[PanelType] [varchar](100) NULL,
	[Specimen] [varchar](max) NULL,
	[DiagnosisGroup] [varchar](max) NULL,
	[DiagnosisId] [int] NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PanelMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO