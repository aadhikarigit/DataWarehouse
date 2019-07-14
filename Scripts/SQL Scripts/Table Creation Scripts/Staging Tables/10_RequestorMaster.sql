USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[RequestorMaster]    Script Date: 7/8/2019 3:16:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RequestorMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[_OrigRequestorId] [int] NOT NULL,
	[RequestorName] [varchar](200) NULL,
	[ReqIsActive] [int] NULL,
	[ReqReqId] [int] NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestorMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO
