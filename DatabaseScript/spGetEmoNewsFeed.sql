/****** Object:  StoredProcedure [tallal78_8].[spGetEmoNewsFeed]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetEmoNewsFeed]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetEmoNewsFeed]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetEmoNewsFeed]
    @EmoId BIGINT ,
    @UserId BIGINT ,
    @PageNumber BIGINT ,
    @RowsPerPage BIGINT
AS
    BEGIN
        WITH    CTE
                  AS ( SELECT   ( RANK() OVER ( ORDER BY p.id ) ) AS RankNumber ,
                                PT.EmotionId ,
                                Ptu.UserId ,
                                P.Link ,
                                P.Website_Id ,
                                p.Id ,
                                P.Title ,
                                P.Description ,
                                P.Image ,
                                ISNULL(PT.Date, GETDATE()) AS CreatedOn
                       FROM     Premalink_Emotions PT
                                INNER JOIN Premalink_Emotions_User PTU ON PTU.Premalink_Emotions_Id = pt.Id
                                INNER JOIN Premalink P ON P.Id = PT.PremalinkId
                       WHERE    CASE WHEN @EmoId <> 0 THEN PT.EmotionId
                                     ELSE @EmoId
                                END = @EmoId
                                AND PTU.UserId = @UserId
                     )
            SELECT  c.RankNumber ,
                    ISNULL(PT.Tag_Id, 0) AS Tag_Id ,
                    ( SELECT    Name
                      FROM      Tag
                      WHERE     id = PT.Tag_Id
                    ) AS TagName ,
                    1 AS UpVote ,
                    0 AS DownVote ,
                    1 AS TotalVote ,
                    CASE WHEN c.UserId = 1 THEN 'true'
                         ELSE 'false'
                    END AS TaggedByUser ,
                    ( SELECT    ISNULL(E.Name, '')
                      FROM      Emotions E
                      WHERE     E.id = PE.EmotionId
                    ) AS EmotionName ,
                    ( SELECT    COUNT(PEU.Id)
                      FROM      Premalink_Emotions_User PEU
                      WHERE     Premalink_Emotions_Id = PE.Id
                    ) AS TotalCount ,
                    ( SELECT    ISNULL(PEU.Id, 0)
                      FROM      Premalink_Emotions_User PEU
                      WHERE     PEU.Premalink_Emotions_Id = PE.Id
                                AND PEU.UserId = @EmoId
                    ) AS UserEmotion ,
                    ISNULL(c.Link, '') AS Link ,
                    ISNULL(c.Website_Id, 0) AS Website_Id ,
                    ( SELECT    ISNULL(w.Name, '')
                      FROM      Website w
                      WHERE     w.Id = c.Website_Id
                    ) AS WebsiteName ,
                    ISNULL(c.Id, 0) AS PremalinkId ,
                    ISNULL(c.Title, '') AS Title ,
                    ISNULL(c.Description, '') AS Description ,
                    ISNULL(c.Image, '') AS Image ,
                    ISNULL(c.CreatedOn, GETDATE()) AS CreatedOn ,
                    ISNULL(PE.EmotionId, 0) AS EmotionId
            FROM    CTE c
                    LEFT JOIN PremalinkTags PT ON c.Id = PT.Premalink_Id
                    LEFT JOIN Premalink_Emotions PE ON PE.PremalinkId = c.id
            WHERE   ( SELECT    COUNT(PEU.Id)
                      FROM      Premalink_Emotions_User PEU
                      WHERE     Premalink_Emotions_Id = PE.Id
                    ) <> 0
                    AND RankNumber BETWEEN ( ( @PageNumber - 1 )
                                             * @RowsPerPage ) + 1
                                   AND     @RowsPerPage * ( @PageNumber )
            ORDER BY c.CreatedOn DESC
    END

GO
