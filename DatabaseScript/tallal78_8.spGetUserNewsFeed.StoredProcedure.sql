/****** Object:  StoredProcedure [tallal78_8].[spGetUserNewsFeed]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetUserNewsFeed]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetUserNewsFeed]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [tallal78_8].[spGetUserNewsFeed]
    @UserID BIGINT ,
    @PageNumber BIGINT ,
    @RowsPerPage BIGINT
AS
    BEGIN

        WITH    CTE
                  AS ( SELECT   PT.Premalink_Id AS Id ,
                                ( DENSE_RANK() OVER ( ORDER BY PT.Premalink_Id ) ) AS RankNumber
                       FROM     PremalinkTags PT
                                INNER JOIN User_Tag_Follow utf ON PT.Tag_Id = utf.TagId
                       WHERE    utf.UserId = @UserID
                     )
            SELECT  ( SELECT    ISNULL(w.Image, '')
                      FROM      Website w
                      WHERE     w.Id = ( SELECT Website_Id
                                         FROM   Premalink
                                         WHERE  Id = p.Id
                                       )
                    ) AS WebsiteImage ,
                    ( SELECT    ISNULL(w.Name, '')
                      FROM      Website w
                      WHERE     w.Id = ( SELECT Website_Id
                                         FROM   Premalink
                                         WHERE  Id = p.Id
                                       )
                    ) AS WebsiteName ,
                    ( SELECT    ISNULL(w.URL, '')
                      FROM      Website w
                      WHERE     w.Id = ( SELECT Website_Id
                                         FROM   Premalink
                                         WHERE  Id = p.Id
                                       )
                    ) AS WebsiteUrl ,
                    ( SELECT    ISNULL(w.Id, 0)
                      FROM      Website w
                      WHERE     w.Id = ( SELECT Website_Id
                                         FROM   Premalink
                                         WHERE  Id = p.Id
                                       )
                    ) AS WebsiteId ,
                    ISNULL(p.Id, 0) AS PremalinkId ,
                    pt.Tag_Id ,
                    ( SELECT TOP 1
                                RankNumber
                      FROM      CTE e
                      WHERE     e.Id = p.Id
                    ) AS RankNumber ,
                    ( SELECT    t.Name
                      FROM      Tag t
                      WHERE     t.Id = pt.Tag_Id
                    ) AS TagName ,
                    ( SELECT    SUM(ptu.UpVote)
                      FROM      PremalinkTag_User ptu
                      WHERE     ptu.PremalinkTagId = pt.Id
                    ) AS UpVote ,
                    ( SELECT    SUM(ptu.DownVote)
                      FROM      PremalinkTag_User ptu
                      WHERE     ptu.PremalinkTagId = pt.Id
                    ) AS DownVote ,
                    ( ISNULL(( SELECT   SUM(ptu.UpVote)
                               FROM     PremalinkTag_User ptu
                               WHERE    ptu.PremalinkTagId = pt.Id
                             ), 0)
                      - ISNULL(( SELECT SUM(ptu.DownVote)
                                 FROM   PremalinkTag_User ptu
                                 WHERE  ptu.PremalinkTagId = pt.Id
                               ), 0) ) AS TotalVote ,
                    p.Link ,
                    ISNULL(p.Website_Id, 0) AS Website_Id ,
                    p.Title ,
                    p.Description ,
                    p.Image ,
                    ISNULL(pt.Date, GETDATE()) AS CreatedOn ,
                    CASE WHEN ( SELECT  ptu.UserId
                                FROM    PremalinkTag_User ptu
                                WHERE   ptu.PremalinkTagId = pt.Id
                                        AND ptu.UserId = @UserID
                              ) = @UserID THEN 'true'
                         ELSE 'false'
                    END TaggedByUser
            FROM    Premalink p
                    INNER	JOIN PremalinkTags pt ON p.id = pt.Premalink_id
            WHERE   P.id IN ( SELECT    DISTINCT
                                        c.Id
                              FROM      CTE c )
                    AND ( SELECT TOP 1
                                    RankNumber
                          FROM      CTE e
                          WHERE     e.Id = p.Id
                        ) BETWEEN ( ( @PageNumber - 1 ) * @RowsPerPage ) + 1
                          AND     @RowsPerPage * ( @PageNumber )
            ORDER BY RankNumber ASC
    END

GO
