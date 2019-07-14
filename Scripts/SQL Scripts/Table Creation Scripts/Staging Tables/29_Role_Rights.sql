USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Role_Rights]    Script Date: 7/8/2019 3:16:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Role_Rights](
	[RRID] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[RightsId] [int] NOT NULL,
	[IsSync] [bit] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Role_Rights] ADD  DEFAULT ((0)) FOR [IsSync]
GO