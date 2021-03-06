/****** Object:  StoredProcedure [tallal78_8].[spGetAllEmotion]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetAllEmotion]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetAllEmotion]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spGetAllEmotion]
    @WebSiteName VARCHAR(MAX) = '' ,
    @Premalink VARCHAR(MAX) ,
    @UserID BIGINT
AS
    BEGIN

        DECLARE @PremalinkId BIGINT = 0
        DECLARE @WebsiteId BIGINT = 0

        SELECT  @WebsiteId = ISNULL(w.id, 2)
        FROM    Website w
        WHERE   w.Name = @WebSiteName

        IF @WebsiteId = ''
            SET @WebsiteId = 2

        IF @WebSiteName <> ''
            BEGIN
                IF NOT EXISTS ( SELECT  *
                                FROM    Premalink p
                                        JOIN Website w ON w.Id = p.Website_Id
                                WHERE   w.Id = @WebsiteId
                                        AND Link = @Premalink )
                    BEGIN
                        INSERT  INTO [Premalink]
                                ( [Link] ,
                                  [Website_Id] ,
                                  [Site_name] ,
                                  [MetaTagCheck] ,
                                  [CreatedOn]

                                )
                        VALUES  ( @Premalink ,
                                  @WebsiteId ,
                                  @WebSiteName ,
                                  0 ,
                                  GETDATE()
                                )
                    END
            END

        SELECT  e.Id AS EmotionId ,
                e.NAME AS EmotionName ,
                ( ISNULL(( SELECT   COUNT(ptu.id)
                           FROM     Premalink_Emotions_User ptu
                           WHERE    ptu.Premalink_Emotions_Id = pe.Id
                         ), 0) ) AS TotalCount ,
                CASE WHEN @UserID = ( (SELECT   UserId
                                       FROM     Premalink_Emotions_User peu
                                       WHERE    peu.Premalink_Emotions_Id = ( SELECT
                                                              pes.id
                                                              FROM
                                                              Premalink_Emotions pes
                                                              WHERE
                                                              pes.PremalinkId = p.id
                                                              AND pes.EmotionId = e.id
                                                              )
                                                AND peu.UserId = @UserID)
                                    ) THEN 1
                     ELSE 0
                END LoggedUserEmotion ,
                p.MetaTagCheck ,
                p.Link
        FROM    Premalink p
                INNER JOIN Premalink_Emotions pe ON p.id = pe.PremalinkId
                INNER JOIN Emotions e ON pe.EmotionId = e.Id
        WHERE   p.Link = @Premalink
    END

GO
