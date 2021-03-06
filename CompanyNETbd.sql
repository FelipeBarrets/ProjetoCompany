USE [master]
GO
/****** Object:  Database [Program]    Script Date: 20/03/2022 02:21:33 ******/
CREATE DATABASE [Program]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Program', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Program.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Program_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Program_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Program] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Program].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Program] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Program] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Program] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Program] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Program] SET ARITHABORT OFF 
GO
ALTER DATABASE [Program] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Program] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Program] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Program] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Program] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Program] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Program] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Program] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Program] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Program] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Program] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Program] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Program] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Program] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Program] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Program] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Program] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Program] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Program] SET  MULTI_USER 
GO
ALTER DATABASE [Program] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Program] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Program] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Program] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Program] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Program] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Program] SET QUERY_STORE = OFF
GO
USE [Program]
GO
/****** Object:  User [Souza]    Script Date: 20/03/2022 02:21:33 ******/
CREATE USER [Souza] FOR LOGIN [Souza] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Barreto]    Script Date: 20/03/2022 02:21:33 ******/
CREATE USER [Barreto] FOR LOGIN [Barreto] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Aluno]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aluno](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](100) NULL,
	[senha] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Certificados]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certificados](
	[fk_idAluno] [int] NOT NULL,
	[nomeCertificado] [varchar](100) NULL,
	[tipoCertificado] [varchar](20) NULL,
	[horasCertificado] [int] NULL,
	[homologacao] [varchar](3) NOT NULL,
	[pdfCertificado] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Professor]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professor](
	[emailProf] [varchar](100) NOT NULL,
	[senhaProf] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[emailProf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Certificados]  WITH CHECK ADD  CONSTRAINT [id] FOREIGN KEY([fk_idAluno])
REFERENCES [dbo].[Aluno] ([id])
GO
ALTER TABLE [dbo].[Certificados] CHECK CONSTRAINT [id]
GO
/****** Object:  StoredProcedure [dbo].[adicionarAluno]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[adicionarAluno] (@email varchar(100),@senha varchar(20)) as
insert into Aluno values (@email,@senha)
GO
/****** Object:  StoredProcedure [dbo].[adicionarCertificado]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[adicionarCertificado] ( @nomeCertificado varchar(100),@tipoCertificado varchar(20), @horasCertificado int, @email varchar(100),@pdf image)
as
declare @Id int
exec verificarId @email, @Id out
Insert into Certificados (fk_idAluno,nomeCertificado,tipoCertificado,horasCertificado,homologacao,pdfCertificado)
values (@Id,@nomeCertificado,@tipoCertificado,@horasCertificado,'nao',@pdf);

GO
/****** Object:  StoredProcedure [dbo].[ConsultarCertificados]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ConsultarCertificados](@email varchar(100)) 
as
select * from Certificados C 
join Aluno A on A.id = C.fk_idAluno where A.email=@email 
GO
/****** Object:  StoredProcedure [dbo].[listarAlunos]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarAlunos] as select email from Aluno
GO
/****** Object:  StoredProcedure [dbo].[listarCertificados]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[listarCertificados] 
as
select * from Certificados C 
join Aluno A on A.id = C.fk_idAluno 
GO
/****** Object:  StoredProcedure [dbo].[verificarId]    Script Date: 20/03/2022 02:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[verificarId](@email varchar(100), @Id int out) 
as
select @id = A.id from Aluno A where A.email= @email
GO
USE [master]
GO
ALTER DATABASE [Program] SET  READ_WRITE 
GO
