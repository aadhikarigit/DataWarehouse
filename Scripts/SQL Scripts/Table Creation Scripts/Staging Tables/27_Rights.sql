USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Rights]    Script Date: 7/8/2019 3:16:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Rights](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[_OrigRightsId] [int] NOT NULL,
	[RightsName] [varchar](50) NULL,
	[RightDesc] [varchar](max) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Rights] ADD  DEFAULT ((0)) FOR [IsSync]
GO
