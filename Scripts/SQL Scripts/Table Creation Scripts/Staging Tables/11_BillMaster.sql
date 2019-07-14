USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[BillMaster]    Script Date: 7/8/2019 2:59:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BillMaster](
	[BillMasterID] [int] IDENTITY(1,1) NOT NULL,
	[BillNo] [varchar](20) NOT NULL,
	[_PatientId] [int] NOT NULL,
	[BillDate] [datetime] NOT NULL,
	[BillPrice] [money] NOT NULL,
	[BillDiscount] [float] NOT NULL,
	[BillHSTAmount] [money] NOT NULL,
	[BillTotal] [money] NOT NULL,
	[BillPaid] [money] NOT NULL,
	[BillBalance] [money] NOT NULL,
	[IsOutGoing] [bit] NOT NULL,
	[BillPaymentType] [varchar](50) NULL,
	[BillOutgoingAmt] [money] NULL,
	[BillOutgoingDiscAmt] [money] NULL,
	[BillOutgoingPct] [float] NULL,
	[BillVoid] [bit] NULL,
	[BillCreatedBy] [varchar](100) NULL,
	[BillModifiedBy] [varchar](100) NULL,
	[BillModifiedDate] [datetime] NULL,
	[IsSync] [bit] NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BillMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BillMaster] ADD  DEFAULT ((0)) FOR [IsSync]
GO



