USE [Polyclinic]
GO
/****** Object:  Table [dbo].[Compositions]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compositions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ingredients_id] [int] NULL,
	[medicines_id] [int] NULL,
	[amount] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contraindications]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contraindications](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[patients_id] [int] NULL,
	[ingredients_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctors]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[identification_code] [char](10) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[specialization] [nvarchar](100) NOT NULL,
	[address] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identification_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ingredients]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingredients](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[unit] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medicines]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicines](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[identification_code] [char](10) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[address] [nvarchar](255) NULL,
	[special_accounting] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[identification_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[treatment_id] [int] NULL,
	[ingredients_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Treatment]    Script Date: 19.03.2025 23:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Treatment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[patients_id] [int] NULL,
	[doctors_id] [int] NULL,
	[diagnosis] [nvarchar](255) NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NULL,
	[effectiveness] [int] NULL,
	[status] [nvarchar](50) NULL,
	[note] [nvarchar](500) NULL,
	[diagnosis_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Compositions]  WITH CHECK ADD  CONSTRAINT [fk_compositions_ingredients] FOREIGN KEY([ingredients_id])
REFERENCES [dbo].[Ingredients] ([id])
GO
ALTER TABLE [dbo].[Compositions] CHECK CONSTRAINT [fk_compositions_ingredients]
GO
ALTER TABLE [dbo].[Compositions]  WITH CHECK ADD  CONSTRAINT [fk_compositions_medicines] FOREIGN KEY([medicines_id])
REFERENCES [dbo].[Medicines] ([id])
GO
ALTER TABLE [dbo].[Compositions] CHECK CONSTRAINT [fk_compositions_medicines]
GO
ALTER TABLE [dbo].[Contraindications]  WITH CHECK ADD  CONSTRAINT [fk_contraindications_ingredients] FOREIGN KEY([ingredients_id])
REFERENCES [dbo].[Ingredients] ([id])
GO
ALTER TABLE [dbo].[Contraindications] CHECK CONSTRAINT [fk_contraindications_ingredients]
GO
ALTER TABLE [dbo].[Contraindications]  WITH CHECK ADD  CONSTRAINT [fk_contraindications_patients] FOREIGN KEY([patients_id])
REFERENCES [dbo].[Patients] ([id])
GO
ALTER TABLE [dbo].[Contraindications] CHECK CONSTRAINT [fk_contraindications_patients]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [fk_prescription_ingredients] FOREIGN KEY([ingredients_id])
REFERENCES [dbo].[Ingredients] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [fk_prescription_ingredients]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [fk_prescription_treatment] FOREIGN KEY([treatment_id])
REFERENCES [dbo].[Treatment] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [fk_prescription_treatment]
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD  CONSTRAINT [fk_treatment_doctors] FOREIGN KEY([doctors_id])
REFERENCES [dbo].[Doctors] ([id])
GO
ALTER TABLE [dbo].[Treatment] CHECK CONSTRAINT [fk_treatment_doctors]
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD  CONSTRAINT [fk_treatment_patients] FOREIGN KEY([patients_id])
REFERENCES [dbo].[Patients] ([id])
GO
ALTER TABLE [dbo].[Treatment] CHECK CONSTRAINT [fk_treatment_patients]
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD  CONSTRAINT [chk_treatment_status_completed] CHECK  (([status]='Pending' OR [status]='Ongoing' OR [status]='Completed' AND [end_date] IS NOT NULL))
GO
ALTER TABLE [dbo].[Treatment] CHECK CONSTRAINT [chk_treatment_status_completed]
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD CHECK  (([effectiveness]>=(0) AND [effectiveness]<=(100)))
GO
ALTER TABLE [dbo].[Treatment]  WITH CHECK ADD CHECK  (([status]='Pending' OR [status]='Ongoing' OR [status]='Completed'))
GO
