USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Roles]    Script Date: 7/8/2019 3:17:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Roles](
	[RID] [int] IDENTITY(1,1) NOT NULL,
	[_OrigRoleId] [int] NOT NULL,
	[RoleName] [nvarchar](50) NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Roles] ADD  DEFAULT ((0)) FOR [IsSync]
GO
