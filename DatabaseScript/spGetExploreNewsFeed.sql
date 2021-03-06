/****** Object:  StoredProcedure [tallal78_8].[spGetExploreNewsFeed]    Script Date: 10/13/2014 10:18:49 PM ******/
DROP PROCEDURE [tallal78_8].[spGetExploreNewsFeed]
GO
/****** Object:  StoredProcedure [tallal78_8].[spGetExploreNewsFeed]    Script Date: 10/13/2014 10:18:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [tallal78_8].[spGetExploreNewsFeed]
    @UserID BIGINT = 0 ,
    @TagId BIGINT ,
    @PageNumber BIGINT ,
    @RowsPerPage BIGINT
AS
    BEGIN


        WITH    CTE
                  AS ( SELECT   ( RANK() OVER ( ORDER BY p.id ) ) AS RankNumber ,
                                PT.Tag_Id ,
                                PTU.UpVote ,
                                PTU.DownVote ,
                                Ptu.UserId ,
                                P.Link ,
                                P.Website_Id ,
                                p.Id ,
                                P.Title ,
                                P.Description ,
                                P.Image ,
                                ( ISNULL(PTU.UpVote, 0) - ISNULL(PTU.DownVote,
                                                              0) ) AS TotalVote ,
                                ISNULL(PT.Date, GETDATE()) AS CreatedOn
                       FROM     PremalinkTags PT
                                INNER JOIN PremalinkTag_User PTU ON PTu.PremalinkTagId = pt.Id
                                INNER JOIN Premalink P ON P.Id = PT.Premalink_Id
                       WHERE    ( ISNULL(PTU.UpVote, 0) - ISNULL(PTU.DownVote,
                                                              0) ) <> 0
                     ),
                CTE1
                  AS ( SELECT   UTF.Premalink_Id
                       FROM     PremalinkTags UTF
                       WHERE    UTF.Tag_Id = @TagId
                     )
            SELECT  c.RankNumber ,
                    ISNULL(c.Tag_Id, 0) AS Tag_Id ,
                    ( SELECT    Name
                      FROM      Tag
                      WHERE     id = c.Tag_Id
                    ) AS TagName ,
                    ISNULL(c.UpVote, 0) AS UpVote ,
                    ISNULL(c.DownVote, 0) AS DownVote ,
                    CASE WHEN c.UserId = @UserID THEN 'true'
                         ELSE 'fasle'
                    END AS TaggedByUser ,
                    c.Link ,
                    ISNULL(c.Website_Id, 0) AS Website_Id ,
                    ISNULL(c.Id, 0) AS PremalinkId ,
                    c.Title ,
                    c.Description ,
                    c.Image ,
                    ISNULL(c.TotalVote, 0) AS TotalVote ,
                    c.CreatedOn
            FROM    CTE c
                    INNER JOIN CTE1 d ON c.Id = d.Premalink_Id
            WHERE   RankNumber BETWEEN ( ( @PageNumber - 1 ) * @RowsPerPage )
                                       + 1
                               AND     @RowsPerPage * ( @PageNumber )
            ORDER BY c.CreatedOn DESC

    END

GO
