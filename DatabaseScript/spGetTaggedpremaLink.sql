/****** Object:  StoredProcedure [tallal78_8].[spGetTaggedpremaLink]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetTaggedpremaLink]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetTaggedpremaLink]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetTaggedpremaLink]
    @TagID INT ,
    @PageNumber INT ,
    @RowsPerPage INT
AS
    BEGIN
     
        WITH    Prema
                  AS ( SELECT   p.[Id] ,
                                [Link] ,
                                [Title] ,
                                [Site_name] ,
                                [Description] ,
                                [Image] ,
                                [Published_time]
                       FROM     Premalink p
                                JOIN PremalinkTags pt ON p.Id = pt.Premalink_Id
                       WHERE    pt.Tag_Id = @TagID
                     ),
                PremaTag
                  AS ( SELECT   t.Id ,
                                t.Name ,
                                pt.Premalink_Id
                       FROM     Tag t
                                JOIN PremalinkTags pt ON t.Id = pt.Tag_Id
                     )
            SELECT  p.Id AS PremalinkID ,
                    pt.Name AS TagName ,
                    pt.Id AS TagID ,
                    p.Link AS Link ,
                    p.Title AS Title ,
                    p.Site_name ,
                    p.Description ,
                    p.Image ,
                    p.Published_time
            FROM    Prema p
                    JOIN PremaTag pt ON p.Id = pt.Premalink_Id
            ORDER BY p.Id DESC
                    OFFSET ( @PageNumber - 1 ) * @RowsPerPage ROWS
			FETCH NEXT @RowsPerPage ROWS ONLY

    END
GO
