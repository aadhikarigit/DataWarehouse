USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[SubTestMaster]    Script Date: 6/20/2019 4:55:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SubTestMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_SubTestIdOrig] [int] NOT NULL,
	[SubTestName] [nvarchar](max) NULL,
	[SubTestGroup] [nvarchar](max) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[ParentSubTestId] [int] NULL,
	[ParentSubTest] [nvarchar](max) NULL,
	[IsActive] [int] NOT NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NOT NULL,
	[UpdateTs] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[SubTestMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO


