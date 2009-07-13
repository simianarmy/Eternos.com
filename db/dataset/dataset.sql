-- MySQL dump 10.11
--
-- Host: localhost    Database: eternos_test
-- ------------------------------------------------------
-- Server version	5.0.51b

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `full_domain` varchar(255) default NULL,
  `subscription_discount_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_accounts_on_subscription_discount_id` (`subscription_discount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_stream_items`
--

DROP TABLE IF EXISTS `activity_stream_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `activity_stream_items` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` int(11) default NULL,
  `updated_at` int(11) default NULL,
  `published_on` datetime default NULL,
  `guid` varchar(255) default NULL,
  `message` text,
  `attachment_data` text,
  `attachment_type` varchar(255) default NULL,
  `activity_type` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  `activity_stream_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_activity_stream_items_on_activity_stream_id` (`activity_stream_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `activity_stream_items`
--

LOCK TABLES `activity_stream_items` WRITE;
/*!40000 ALTER TABLE `activity_stream_items` DISABLE KEYS */;
INSERT INTO `activity_stream_items` VALUES (1,1242801109,1247463025,'2009-05-20 06:31:49',NULL,'is cranking along on about four different projects, and all are going swimmingly... sleep calls!',NULL,NULL,'status','FacebookActivityStreamItem',1),(2,1242834849,1247463025,'2009-05-20 15:54:09',NULL,'fascinated by this story...','--- \nhref: http://www.facebook.com/ext/share.php?sid=82878347698&amp;h=lx-KU&amp;u=EsgI9\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=efe120d59adafaf3decac07f2c0ae410&amp;url=http%3A%2F%2Facidcow.com%2Fcontent%2Fimg%2Fnew03%2F25%2F22.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(3,1242932961,1247463026,'2009-05-21 19:09:21',NULL,'learning about the history of weed, thanks Showtime!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81970569404&amp;h=CqUBk&amp;u=znUr6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2686a5b094f8b59355897de6bad9f27c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FzfiaC-2K1LM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=81970569404#s81970569404\n  source_url: http://www.youtube.com/v/zfiaC-2K1LM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=zfiaC-2K1LM&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: History of Weed\n','video','post','FacebookActivityStreamItem',1),(4,1243017368,1247463026,'2009-05-22 18:36:08',NULL,'wonders why people put up with this police state bullshit.  OMG!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108514165791&amp;h=4VyLp&amp;u=5M5QB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d9240500226b1d1587b91b6027b7cfe9&amp;url=http%3A%2F%2Fwww.wired.com%2Fimages_blogs%2Fthreatlevel%2F2009%2F05%2Ffcc_badge.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(5,1243104872,1247463026,'2009-05-23 18:54:32',NULL,'is thinking about taking a long stroll at folklife and stuffing my face for as many hours as possible in the sun today :)',NULL,NULL,'status','FacebookActivityStreamItem',1),(6,1243109730,1247463026,'2009-05-23 20:15:30',NULL,'just blocked ten people from his newsfeed for taking those obnoxious quizzes.',NULL,NULL,'status','FacebookActivityStreamItem',1),(7,1243183947,1247463026,'2009-05-24 16:52:27',NULL,'is in the midst of having a mindblowingly good weekend!',NULL,NULL,'status','FacebookActivityStreamItem',1),(8,1243211850,1247463026,'2009-05-25 00:37:30',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1810565&amp;id=504883639\nphoto: \n  pid: \"2168458717792280709\"\n  aid: \"2168458717790550922\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_83405843639_504883639_1810565_5659759_s.jpg\ntype: photo\nalt: IMG_1180\n','photo','post','FacebookActivityStreamItem',1),(9,1243307660,1247463026,'2009-05-26 03:14:20',NULL,'A man with one watch knows what time it is; a man with two watches is never quite sure.  ~Lee Segall',NULL,NULL,'status','FacebookActivityStreamItem',1),(10,1243316488,1247463026,'2009-05-26 05:41:28',NULL,'is watching this astounding mechanical Lego pirate theater, controlled by Mindstorm/Nextstorm robot Lego, marries the Victorian dramatic clockwork automaton with 21st century cheap computation and precision brick-making. And it\'s got pirates! Seriously, some people have WAAAAY too much time on their hands!','--- \nhref: http://www.facebook.com/ext/share.php?sid=106651591257&amp;h=kdY6S&amp;u=s5j3S\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=e4a2b0b9f01d04041cad03744009e5f6&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FIkDsre1ltvk%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=106651591257#s106651591257\n  source_url: http://www.youtube.com/v/IkDsre1ltvk&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=IkDsre1ltvk&amp;\n  owner: \"504883639\"\nalt: LEGO Mindstorms NXT, Pirates and the NXTfied Theater\n','video','post','FacebookActivityStreamItem',1),(11,1243357205,1247463026,'2009-05-26 17:00:05',NULL,'it slices!  It dices!  This thing is bad ass!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81641852983&amp;h=n4lgk&amp;u=_GaYx\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a705865d808e7268740ddbbcd765c8d6&amp;url=http%3A%2F%2Fstatic.gamesbyemail.com%2FNews%2FDiceOMatic%2FCameraLights.jpg%3F633789125654312915&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(12,1243441474,1247463026,'2009-05-27 16:24:34',NULL,'so not funny, it\'s funny.  Well, not really.  More just morbidly entertaining...','--- \nhref: http://www.facebook.com/ext/share.php?sid=179221960031&amp;h=B78ga&amp;u=vCExk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=40b122d8dd7a50addbf04cdd51ad440d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FA9QpOfhAPXs%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=179221960031#s179221960031\n  source_url: http://www.youtube.com/v/A9QpOfhAPXs&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=A9QpOfhAPXs&amp;eurl=http://www.cracked.com/blog/i-quit-comedy-the-best-video-of-all-time&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: I\'m on a Couch (The Lonely Island - &quot;I\'m on a Boat&quot; parody spoof)\n','video','post','FacebookActivityStreamItem',1),(13,1243456660,1247463026,'2009-05-27 20:37:40',NULL,'watching a dude dialup to the Internet using a 1964 300 bps modem.  &lt;geek&gt;','--- \nhref: http://www.facebook.com/ext/share.php?sid=109788136258&amp;h=yWGGN&amp;u=eZd9P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0095242ec2c2bf10e68b1688ccf5a35f&amp;url=http%3A%2F%2Fgadgets.boingboing.net%2F2009%2F05%2F27%2Fstyle%2Fatboingboing.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(14,1243544478,1247463026,'2009-05-28 21:01:18',NULL,'totally worth the watch... starts slow builds up to a hilarious result... two baseball teams tired of waiting five hours in a rain delay decide to have a dance off!  They are GOOD!','--- \nhref: http://www.facebook.com/ext/share.php?sid=99311083648&amp;h=Lhn3M&amp;u=hyjHN\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f501750d502ba518131ebeb2b385ec6a&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FaazG7dMhE7I%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=99311083648#s99311083648\n  source_url: http://www.youtube.com/v/aazG7dMhE7I&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=aazG7dMhE7I&amp;eurl=http://ourkitchensink.com/2009/05/27/the-greatest-moment-in-rain-delay-history/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Dance Off USF vs Uconn 2009 Big East Baseball Tournament as seen on PTI.\n','video','post','FacebookActivityStreamItem',1),(15,1243566257,1247463026,'2009-05-29 03:04:17',NULL,'gives props to Eminem for returning to old form.  WOW.  His new album is *stunning*.',NULL,NULL,'status','FacebookActivityStreamItem',1),(16,1243610445,1247463026,'2009-05-29 15:20:45',NULL,'decision time tonight.  at least my decision is easy!','--- \nhref: http://www.facebook.com/ext/share.php?sid=82828673175&amp;h=yX4sK&amp;u=atDk6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=668c5c66381d93ec70db2dd972a7ef08&amp;url=http%3A%2F%2Fflowingdata.com%2Fwp-content%2Fuploads%2F2009%2F01%2Fgoldstarman2-545x385.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(17,1243616325,1247463026,'2009-05-29 16:58:45',NULL,'thinks birds are smart.','--- \nhref: http://www.facebook.com/ext/share.php?sid=105618949438&amp;h=n5fEv&amp;u=9Sg5-\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3f58aa412bc6316764a6c7eac424bb5d&amp;url=http%3A%2F%2Fwww.telegraph.co.uk%2Ftelegraph%2Fmultimedia%2Farchive%2F01111%2Fxelect60_1111910h.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(18,1243638613,1247463026,'2009-05-29 23:10:13',NULL,'fun!  shot entirely with a still camera (wait till end to see making of)','--- \nhref: http://www.facebook.com/ext/share.php?sid=87034512396&amp;h=rRhGW&amp;u=3eYwl\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=4f7dd0eea4d34686376352078d4ec53c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FPgpRz3RHJMw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=87034512396#s87034512396\n  source_url: http://www.youtube.com/v/PgpRz3RHJMw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=PgpRz3RHJMw&amp;eurl=http://www.boingboing.net/2009/05/29/sorry-im-late-stop-m.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Sorry i\'m late\n','video','post','FacebookActivityStreamItem',1),(19,1243732517,1247463026,'2009-05-31 01:15:17',NULL,'had an amazing day with his son, Lena, and Robin - teeball game, miniature golf, trampolines, and building a dam on the beach.  Holy &amp;!@# pure heaven in this weather!',NULL,NULL,'status','FacebookActivityStreamItem',1),(20,1243735661,1247463026,'2009-05-31 02:07:41',NULL,'','--- \nname: I farted in your face and then you stole my wallet\nhref: http://www.facebook.com/group.php?gid=81615419170\nfb_object_id: \"81615419170\"\nfb_object_type: group\nicon: http://static.ak.fbcdn.net/images/icons/group.gif?8:25796\nmedia: {}\n\ncaption: Common Interest - Activities\ndescription: Has this happened to you?\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1),(21,1243840538,1247463026,'2009-06-01 07:15:38',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843134&amp;id=504883639\nphoto: \n  pid: \"2168458717792313278\"\n  aid: \"2168458717790552260\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679763639_504883639_1843134_4182462_s.jpg\ntype: photo\nalt: IMG_1187\n','photo','post','FacebookActivityStreamItem',1),(22,1243840718,1247463026,'2009-06-01 07:18:38',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843146&amp;id=504883639\nphoto: \n  pid: \"2168458717792313290\"\n  aid: \"2168458717790552261\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680338639_504883639_1843146_7216025_s.jpg\ntype: photo\nalt: IMG_1200\n','photo','post','FacebookActivityStreamItem',1),(23,1243881242,1247463026,'2009-06-01 18:34:02',NULL,'The Coolest House in the Neighborhood (And Maybe the Galaxy)','--- \nhref: http://www.facebook.com/ext/share.php?sid=180076720315&amp;h=GlJnM&amp;u=rs_SR\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d06b5a211c3893aeca0b1a8a670e6c22&amp;url=http%3A%2F%2Fcdn-i.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17435%2Ffuturehouse_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(24,1243887231,1247463026,'2009-06-01 20:13:51',NULL,'Dear Media, I\'ve had enough hearing about Susan Boyle.  KKTHXBAI.',NULL,NULL,'status','FacebookActivityStreamItem',1),(25,1243975980,1247463027,'2009-06-02 20:53:00',NULL,'won a poker tournament last night.  What a rush!',NULL,NULL,'status','FacebookActivityStreamItem',1),(26,1243990928,1247463027,'2009-06-03 01:02:08',NULL,'is melting from the heat',NULL,NULL,'status','FacebookActivityStreamItem',1),(27,1244084494,1247463027,'2009-06-04 03:01:34',NULL,'totally sacked out for a nap in 85 degree heat with a modicum of clothing on... for three hours... ouch....',NULL,NULL,'status','FacebookActivityStreamItem',1),(28,1244094353,1247463027,'2009-06-04 05:45:53',NULL,'is starting to think evil thoughts...','--- \nhref: http://www.facebook.com/ext/share.php?sid=101500368271&amp;h=TU3MC&amp;u=DK_Hs\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a6483ba371ea7faa040fca781bc7463d&amp;url=http%3A%2F%2Fhowto.wired.com%2Fmediawiki%2Fimages%2FSt_howto_explodingdrink.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(29,1244148255,1247463027,'2009-06-04 20:44:15',NULL,'finally understands the biblical meaning of &quot;Marriage&quot;','--- \nhref: http://www.facebook.com/ext/share.php?sid=105295259883&amp;h=4AOfZ&amp;u=LFkY6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47f44c7b17752fe0548a5ba0d688b4bb&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FOFkeKKszXTw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=105295259883#s105295259883\n  source_url: http://www.youtube.com/v/OFkeKKszXTw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=OFkeKKszXTw\n  owner: \"504883639\"\nalt: Betty Bowers Explains Traditional Marriage to Everyone Else\n','video','post','FacebookActivityStreamItem',1),(30,1244220880,1247463027,'2009-06-05 16:54:40',NULL,'really, really can\'t stand conan o\'brien.  I\'ve tried.  Three times this week.  To laugh even a little at his tired old schtick.  Sometimes, I laugh during the commercials, but never during the program.  Bed time is at 11:30 for me now apparently :(',NULL,NULL,'status','FacebookActivityStreamItem',1),(31,1244342375,1247463027,'2009-06-07 02:39:35',NULL,'is having a great day with his son!',NULL,NULL,'status','FacebookActivityStreamItem',1),(32,1244487999,1247463027,'2009-06-08 19:06:39',NULL,'Give me my iPhone 3G 3.0 OS!  I\'ll pass on the hardware upgrade for this generation tho.',NULL,NULL,'status','FacebookActivityStreamItem',1),(33,1244516678,1247463027,'2009-06-09 03:04:38',NULL,'finally an upgrade to my ][GS, I now can get a THREE-GS!  Sweet thanks apple!',NULL,NULL,'status','FacebookActivityStreamItem',1),(34,1244517616,1247463027,'2009-06-09 03:20:16',NULL,'just hid three more friends for taking these totally inane quizzes with artificially random results that just do nothing but clog up my newsfeed.  Die facebook quizzes. Die.',NULL,NULL,'status','FacebookActivityStreamItem',1),(35,1244590254,1247463027,'2009-06-09 23:30:54',NULL,'wants you to check out the new website I did for my girlfriend and let me know what you think.  See if you can find the dirty pics!','--- \nhref: http://www.facebook.com/ext/share.php?sid=103480538944&amp;h=C7yFJ&amp;u=wde24\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a10de2e5a4bf01d31726c7e2610d8f77&amp;url=http%3A%2F%2Fwww.fairmontolympicweddings.com%2Fwp-content%2Fthemes%2Ffairmont%2Fimages%2Fcontent.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(36,1244602575,1247463027,'2009-06-10 02:56:15',NULL,'feels GREAT!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108019026344&amp;h=tM7Jg&amp;u=semhb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=df9126c53ac6412f984931658a88de8c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJC2gIPnUCgw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=108019026344#s108019026344\n  source_url: http://www.youtube.com/v/JC2gIPnUCgw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=JC2gIPnUCgw\n  owner: \"504883639\"\nalt: nutrigrain commercial\n','video','post','FacebookActivityStreamItem',1),(37,1244614395,1247463027,'2009-06-10 06:13:15',NULL,'is enjoying the nice WARM weather.  Not hot.  Not cold.  Just RIGHT.',NULL,NULL,'status','FacebookActivityStreamItem',1),(38,1244664310,1247463027,'2009-06-10 20:05:10',NULL,'has opened Eternos.com for Beta registration.  Please go register your email address to get notified soon as we open for beta!','--- \nhref: http://www.facebook.com/ext/share.php?sid=218902860009&amp;h=ftCC5&amp;u=hs2qW\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=bda5b9c79c7f2f28885c578aef99666a&amp;url=http%3A%2F%2Fwww.eternos.com%2Fimages%2Fbeta.gif%3F1244663389&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(39,1244677385,1247463027,'2009-06-10 23:43:05',NULL,'this is why I hate the government.  And some people want them to run health care??  $9 TRILLION dollars in off-balance sheet transactions, and no monitoring system in place for public review?  It really is no joke this country has been sold off in pieces and we all better start learning Chinese.  And I\'m not exaggerating or overreacting.  It\'s pretty sad.','--- \nhref: http://www.facebook.com/ext/share.php?sid=115462236627&amp;h=RUPFY&amp;u=EZhjM\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a94b39c20594b199be1dce1dbbf2ee52&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FcJqM2tFOxLQ%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=115462236627#s115462236627\n  source_url: http://www.youtube.com/v/cJqM2tFOxLQ&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=cJqM2tFOxLQ&amp;eurl=http://dailybail.com/home/there-are-no-words-to-describe-the-following-part-ii.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"High Quality Version: Is Anyone Minding the Store at the Federal Reserve?\"\n','video','post','FacebookActivityStreamItem',1),(40,1244769600,1247463027,'2009-06-12 01:20:00',NULL,'for some reason it feels like Friday to me today.',NULL,NULL,'status','FacebookActivityStreamItem',1),(41,1244788595,1247463027,'2009-06-12 06:36:35',NULL,'pretty much has the best girlfriend ever!',NULL,NULL,'status','FacebookActivityStreamItem',1),(42,1244837706,1247463027,'2009-06-12 20:15:06',NULL,'anyone want to watch my adorable Pug, Borf, for 10 days starting July 1st while I\'m in Hawaii?  Pleeeeaseeee',NULL,NULL,'status','FacebookActivityStreamItem',1),(43,1244849489,1247463027,'2009-06-12 23:31:29',NULL,'is in love with the best of the best!',NULL,NULL,'status','FacebookActivityStreamItem',1),(44,1244867327,1247463027,'2009-06-13 04:28:47',NULL,'is now known as http://www.facebook.com/nerolabs  Vanity username for the win!',NULL,NULL,'status','FacebookActivityStreamItem',1),(45,1244915490,1247463027,'2009-06-13 17:51:30',NULL,'is looking at a NATURAL tree fall in West Seattle.  AWESOME!','--- \nhref: http://www.facebook.com/ext/share.php?sid=89287909614&amp;h=gCBLX&amp;u=pSsbK\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7fae08aa639d8494b14ae42f3ee74c29&amp;url=http%3A%2F%2Fwestseattleblog.com%2Fblog%2Fwp-content%2Fuploads%2F2009%2F06%2Fzzmonster.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(46,1245013697,1247463027,'2009-06-14 21:08:17',NULL,'Hours of Operation','--- \nhref: http://www.facebook.com/ext/share.php?sid=95673251446&amp;h=IoOd6&amp;u=lHqBi\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=16e0d51c53a84c99b2d8089350decb2f&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3080%2F3152352551_706d9ca6a1_o.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(47,1245024708,1247463027,'2009-06-15 00:11:48',NULL,'Sunday is cleaning and bills paying night and getting ready for the next week!',NULL,NULL,'status','FacebookActivityStreamItem',1),(48,1245034816,1247463027,'2009-06-15 03:00:16',NULL,'Gratz to the Lakers.  Kobe, on the other hand, can suck me.',NULL,NULL,'status','FacebookActivityStreamItem',1),(49,1245109663,1247463028,'2009-06-15 23:47:43',NULL,'~32,000 American Scientists Agree:  Global Warming is BULLSHIT','--- \nhref: http://www.facebook.com/ext/share.php?sid=190996770074&amp;h=GHGJU&amp;u=8Lymb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c635339fa7f617c17b6dc569080115b1&amp;url=http%3A%2F%2Fwww.campaignforliberty.com%2Fimg%2Fauthor%2Fpaul.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(50,1245138308,1247463028,'2009-06-16 07:45:08',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1917001&amp;id=504883639\nphoto: \n  pid: \"2168458717792387145\"\n  aid: \"2168458717790555233\"\n  index: \"3\"\n  height: \"403\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/s504883639_1917001_8036523.jpg\ntype: photo\nalt: 004_4\n','photo','post','FacebookActivityStreamItem',1),(51,1245179284,1247463028,'2009-06-16 19:08:04',NULL,'wants to be a cat','--- \nhref: http://www.facebook.com/ext/share.php?sid=92502495980&amp;h=IYv8n&amp;u=_jEbo\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f73c0c2216fc5c560994fb53943610c9&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJ5Xrcp6k8VE%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=92502495980#s92502495980\n  source_url: http://www.youtube.com/v/J5Xrcp6k8VE&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=J5Xrcp6k8VE&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: How catnip gets cats high\n','video','post','FacebookActivityStreamItem',1),(52,1245185986,1247463028,'2009-06-16 20:59:46',NULL,'thinks Obama is a wolf in sheeps clothing.','--- \nhref: http://www.facebook.com/ext/share.php?sid=91375379508&amp;h=GoMo9&amp;u=RI7y_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=92fae83da333a7ba2d2fb7f127d2a417&amp;url=http%3A%2F%2Fmsnbcmedia.msn.com%2Fj%2FMSNBC%2FComponents%2FBylines%2Fmugs%2FMSNBC%2520Interactive%2Fbill_dedman_2.thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(53,1245198088,1247463028,'2009-06-17 00:21:28',NULL,'if you protest the government in any way, you are a terrorist: straight from the Department of Defense','--- \nhref: http://www.facebook.com/ext/share.php?sid=94299282445&amp;h=2C38f&amp;u=jhdhv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=90b8c2b48180923b4cf51402c2dd7569&amp;url=http%3A%2F%2Fwww.infowars.net%2Fpictures%2Fjune2009%2F150609protest.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(54,1245201101,1247463028,'2009-06-17 01:11:41',NULL,'updated his theme on his blog... check it out','--- \nhref: http://www.facebook.com/ext/share.php?sid=119626995927&amp;h=6_FZ-&amp;u=rrCEL\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b8ee8cb1c8c76b92a89dd4b0de6875d6&amp;url=http%3A%2F%2Fedmondfamily.com%2Fgallery2%2Fmain.php%3Fg2_view%3Dcore.DownloadItem%26g2_itemId%3D3496%26g2_serialNumber%3D2&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(55,1245277861,1247463028,'2009-06-17 22:31:01',NULL,'wonders what &quot;...according to scientists, is that winter temperatures across the Great Plains and Midwest are now some 7Âº warmer than historical norms&quot;.  According to my understanding of the climate, there is NO SUCH THING as a &quot;Historical Norm&quot; when it comes to weather :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=107975996440&amp;h=KPs3X&amp;u=hZDR4\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=756995be59d1549c05817c9ccee0e8e7&amp;url=http%3A%2F%2Fwww.scientificamerican.com%2Fmedia%2Finline%2F000BA112-8AB6-1E83-85F7809EC588EEDF_1_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(56,1245372756,1247463028,'2009-06-19 00:52:36',NULL,'is looking forward to FATHERS DAY!',NULL,NULL,'status','FacebookActivityStreamItem',1),(57,1245427047,1247463028,'2009-06-19 15:57:27',NULL,'reading that Pixar sent an employee with a DVD of \'Up\' to a dying girl as a last wish.  One of the most touching stories I\'ve read in a while... get the tissue out...','--- \nhref: http://www.facebook.com/ext/share.php?sid=99373067465&amp;h=49aMl&amp;u=u_-xX\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=05f012078c4310aaa57bdd0cbc8ee6b8&amp;url=http%3A%2F%2Fimages.ocregister.com%2Fnewsimages%2Fcommunity%2Fhuntingtonbeach%2F2009%2F04%2Fcolby_med.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(58,1245427588,1247463028,'2009-06-19 16:06:28',NULL,'pretty good tilt-shift + time-lapse video!  Love it!','--- \nhref: http://www.facebook.com/ext/share.php?sid=111180392194&amp;h=LJT_t&amp;u=xnhmY\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b1f09016b22c47e4e3362277947ca1f5&amp;url=http%3A%2F%2Fts.vimeo.com.s3.amazonaws.com%2F155%2F790%2F15579090_160.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=111180392194#s111180392194\n  source_url: http://vimeo.com/moogaloop.swf?clip_id=5137183\n  source_type: html\n  display_url: http://vimeo.com/5137183\n  owner: \"504883639\"\nalt: Bathtub V\n','video','post','FacebookActivityStreamItem',1),(59,1245446462,1247463028,'2009-06-19 21:21:02',NULL,'just took my dog to the vet.  Stiff muscles and pinched nerve.  Some doggie aspirin and $72 makes it the cheapest vet visit ever!',NULL,NULL,'status','FacebookActivityStreamItem',1),(60,1245467954,1247463028,'2009-06-20 03:19:14',NULL,'does not get his son on Fathers Day, due to his ex being... well... it\'s not polite to say.  GRRRRR',NULL,NULL,'status','FacebookActivityStreamItem',1),(61,1245471195,1247463028,'2009-06-20 04:13:15',NULL,'Twitter Kills','--- \nhref: http://www.facebook.com/ext/share.php?sid=194616800023&amp;h=Ac9Ve&amp;u=lLmXk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=884f002049d26adf85337b9e315cb5ab&amp;url=http%3A%2F%2Fwww.austriantimes.at%2Fthumbnails%2F6vkkfvy7_tiny.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(62,1245521545,1247463028,'2009-06-20 18:12:25',NULL,'is going on 14 days without seeing or even talking to his son.  Aggressive attorney hired, but legal stuff takes time.  This SUCKS.',NULL,NULL,'status','FacebookActivityStreamItem',1),(63,1245607007,1247463028,'2009-06-21 17:56:47',NULL,'can this be for real?','--- \nhref: http://www.facebook.com/ext/share.php?sid=118330124011&amp;h=gyt0C&amp;u=wG45e\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=66ba91afb2c76e8b3e9c596c7dab0268&amp;url=http%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fa%2Fa4%2FAmphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg%2F240px-Amphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(64,1245692274,1247463028,'2009-06-22 17:37:54',NULL,'thanks everyone for the wonderful birthday and fathers day wishes.  Keep praying that my lawyer gets my son to our family trip in Hawaii and prevents this type of abuse from happening again.',NULL,NULL,'status','FacebookActivityStreamItem',1),(65,1245698952,1247463028,'2009-06-22 19:29:12',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952825&amp;id=504883639\nphoto: \n  pid: \"2168458717792422969\"\n  aid: \"2168458717790556509\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/s504883639_1952825_4167047.jpg\ntype: photo\nalt: IMG_1214\n','photo','post','FacebookActivityStreamItem',1),(66,1245699556,1247463028,'2009-06-22 19:39:16',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952869&amp;id=504883639\nphoto: \n  pid: \"2168458717792423013\"\n  aid: \"2168458717790556513\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"401\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156648639_504883639_1952869_6072646_s.jpg\ntype: photo\nalt: Picture 007\n','photo','post','FacebookActivityStreamItem',1),(67,1245700490,1247463029,'2009-06-22 19:54:50',NULL,'pretty clever','--- \nhref: http://www.facebook.com/ext/share.php?sid=100941976217&amp;h=7Jk8r&amp;u=CfJh_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c83bc162dd40d88c02650232aafcf279&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F3eooXNd0heM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=100941976217#s100941976217\n  source_url: http://www.youtube.com/v/3eooXNd0heM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=3eooXNd0heM&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"Auto-Tune the News #5: lettuce regulation. American blessings.\"\n','video','post','FacebookActivityStreamItem',1),(68,1245703862,1247463029,'2009-06-22 20:51:02',NULL,'more proof that if you tell someone something is &quot;green&quot; that they automatically turn their brains off, or maybe it\'s because the green movement allows for zero skepticism without chastisment.  Sounds like the green movement is taking a cue from the right wing zealots that use peer pressure to sell their beliefs, which more often than not are completely erroneous.','--- \nname: US shoppers misled by greenwash, Congress told | Environment | guardian.co.uk\nhref: http://www.facebook.com/ext/share.php?sid=100787792815&amp;h=MoEzB&amp;u=grkH8\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.guardian.co.uk\"\ndescription: 98% of supposedly environmentally friendly products make potentially false or misleading claims, US campaigners say\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1),(69,1245704433,1247463029,'2009-06-22 21:00:33',NULL,'is looking for people willing to write a Declaration to the court regarding my most awesome Dadness to Jack, as well as can state their opinion regarding Natalie\'s continued assault on me.  Email me at andrew@andrewedmond.com or call me.  I really need as many people as I can that the court will consider credible witnesses.',NULL,NULL,'status','FacebookActivityStreamItem',1),(70,1245726815,1247463029,'2009-06-23 03:13:35',NULL,'is celebrating my birthday AND Robin and I\'s six month anniversary tonight!!  Prayers for Jack welcomed from All!',NULL,NULL,'status','FacebookActivityStreamItem',1),(71,1245735650,1247463029,'2009-06-23 05:40:50',NULL,'just got the hottest, most thoughtful, amazing, kick ass, unbelievable, intense, beautiful, sexy, thoroughly overwhelming birthday present ever from Robin! What a babe!!!!!!!!!!!!!!!!!',NULL,NULL,'status','FacebookActivityStreamItem',1),(72,1245781263,1247463029,'2009-06-23 18:21:03',NULL,'watching a kid FREAK out when his mom cancels his World of Warcraft account.... right as he hits level 80.','--- \nhref: http://www.facebook.com/ext/share.php?sid=120346397177&amp;h=-nksS&amp;u=pdkIJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=8d954d8254903b7e1348821170b5acba&amp;url=http%3A%2F%2F1.media.collegehumor.com%2Fcollegehumor%2Fch6%2F4%2F4%2Fcollegehumor.4a91d1f46db7c43b1aadf864ab8eed36.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=120346397177#s120346397177\n  source_url: http://www.collegehumor.com/moogaloop/moogaloop.swf?clip_id=1915521&amp;autostart=true\n  source_type: html\n  display_url: http://www.collegehumor.com/video:1915521\n  owner: \"504883639\"\nalt: WoW Freakout\n','video','post','FacebookActivityStreamItem',1),(73,1245788340,1247463029,'2009-06-23 20:19:00',NULL,'what an amazing pic!','--- \nhref: http://www.facebook.com/ext/share.php?sid=95087931475&amp;h=PeyhX&amp;u=FtH1t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d33c44e424c9867ffbf9abd89835bb9a&amp;url=http%3A%2F%2Fmsnbcmedia3.msn.com%2Fj%2FMSNBC%2FComponents%2FPhoto%2F_new%2F090622-volcano-hmed2p.hmedium.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(74,1245789767,1247463029,'2009-06-23 20:42:47',NULL,'go go Ron Paul!','--- \nhref: http://www.facebook.com/ext/share.php?sid=112448291083&amp;h=KG3ns&amp;u=qJ-5i\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ac701822824039bb6f753289ae42b930&amp;url=http%3A%2F%2Fwww.lewrockwell.com%2Fpaul%2FGoldPeaceProsperity_T.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(75,1245789911,1247463029,'2009-06-23 20:45:11',NULL,'the truth about family holidays, at last','--- \nname: www.theonion.com\nhref: http://www.facebook.com/ext/share.php?sid=115495881353&amp;h=K1Pxq&amp;u=H8Ftj\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1),(76,1245799420,1247463029,'2009-06-23 23:23:40',NULL,'Picture 1','--- \nhref: http://www.facebook.com/photo.php?pid=1960357&amp;id=504883639\nphoto: \n  pid: \"2168458717792430501\"\n  aid: \"2168458717790556751\"\n  index: \"1\"\n  height: \"348\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93624863639_504883639_1960357_4561644_s.jpg\ntype: photo\nalt: Picture 1\n','photo','post','FacebookActivityStreamItem',1),(77,1245814400,1247463029,'2009-06-24 03:33:20',NULL,'pyramids in the USA.  Also for no discernible purpose.  Huh, who knew?','--- \nhref: http://www.facebook.com/ext/share.php?sid=100881712186&amp;h=pfZPj&amp;u=prfle\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=58c5f969b2219dcccf9b2092d016ae88&amp;url=http%3A%2F%2Fwww.boingboing.net%2F000418l3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(78,1245821960,1247463029,'2009-06-24 05:39:20',NULL,'and we think Iran is effed up?  Really?','--- \nhref: http://www.facebook.com/ext/share.php?sid=107187719051&amp;h=-4SEX&amp;u=VyDWD\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0537f3dd7048cd052f58cb962d057fe6&amp;url=http%3A%2F%2Fi.cdn.turner.com%2Fcnn%2F2009%2FPOLITICS%2F06%2F23%2FUS.syria.ambassador%2Ftzmos.mitchell.assad.gi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(79,1245821994,1247463029,'2009-06-24 05:39:54',NULL,'is determined.  Focused.  Wait, what was I saying?',NULL,NULL,'status','FacebookActivityStreamItem',1),(80,1245823852,1247463029,'2009-06-24 06:10:52',NULL,'a statement about our post-industrial world.  Sublime.','--- \nhref: http://www.facebook.com/ext/share.php?sid=208344885695&amp;h=D8cUH&amp;u=FGR4V\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=fcb3a8a988ac8536644514b3cf561972&amp;url=http%3A%2F%2Fcraphound.com%2Fimages%2Fgoldi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(81,1245824383,1247463029,'2009-06-24 06:19:43',NULL,'get a haircut, please, PLEASE!','--- \nhref: http://www.facebook.com/ext/share.php?sid=107888324048&amp;h=8XTCx&amp;u=Q-Xok\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2a1e086a9955997b1b71c4cec3e2a61c&amp;url=http%3A%2F%2Finlinethumb05.webshots.com%2F26564%2F2444545680105101600S600x600Q85.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(82,1245825959,1247463029,'2009-06-24 06:45:59',NULL,'thanks everyone that has pitched in with help for re-establishing EQUAL custody with my son.  Fatherhood is NOT a privilege granted by Moms... but a RIGHT, even though sometimes we have to fight for it.  Soon... soon....',NULL,NULL,'status','FacebookActivityStreamItem',1),(83,1245855234,1247463029,'2009-06-24 14:53:54',NULL,'finds it funny that the Toyota Prius takes three times more energy to produce than a Hummer, totally offsetting any conceived &quot;savings&quot; to the environment...','--- \nhref: http://www.facebook.com/ext/share.php?sid=112449587867&amp;h=aIAGQ&amp;u=axm5j\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b750bd4b494a647bab291644d6f3bfee&amp;url=http%3A%2F%2Fclubs.ccsu.edu%2Frecorder%2F%2Fmain%2Fccsulogo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(84,1245855848,1247463029,'2009-06-24 15:04:08',NULL,'more environmental shenanigans.  I really wish the green movement had more built in skepticism, but anything goes I supposed!','--- \nhref: http://www.facebook.com/ext/share.php?sid=123982352904&amp;h=utKVR&amp;u=K5J4p\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=974272c296c509112efc3f9cf8377427&amp;url=http%3A%2F%2Fcache.consumerist.com%2Fassets%2Fimages%2F31%2F2009%2F06%2Fpeanut1.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(85,1245856135,1247463029,'2009-06-24 15:08:55',NULL,'a green movement that helps people save money, educate themselves, and is based on real, factual data... this is something I can support!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108698398616&amp;h=3N6pR&amp;u=MM6IJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d8d3cf855dbbdc55463f07b3b5f5b48f&amp;url=http%3A%2F%2Fimages.google.com%2Furl%3Fsource%3Dimgres%26ct%3Dtbn%26q%3Dhttp%3A%2F%2Fblog.infotrends.com%2Fwordpress%2Fwp-content%2Fgallery%2Fgreen-logo%2Fmicrosoft-green_hp.jpg%26usg%3DAFQjCNHJSO4LP0DEMUx9eWR3VY5gMixarQ&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(86,1245856212,1247463029,'2009-06-24 15:10:12',NULL,'fascinating','--- \nhref: http://www.facebook.com/ext/share.php?sid=113961277027&amp;h=yam5X&amp;u=TAurF\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6190c165eb4071ae3bef699460ee0882&amp;url=http%3A%2F%2Fwww.dailymotion.com%2Fthumbnail%2F160x120%2Fvideo%2Fx4muob_zoom-into-a-tooth_tech&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=113961277027#s113961277027\n  source_url: http://www.dailymotion.com/swf/x4muob?autoPlay=1\n  source_type: html\n  display_url: http://www.dailymotion.com/video/x4muob_zoom-into-a-tooth_tech\n  owner: \"504883639\"\nalt: Dailymotion - Zoom into a Tooth - a Tech &amp; Science video\n','video','post','FacebookActivityStreamItem',1),(87,1245859772,1247463029,'2009-06-24 16:09:32',NULL,'Suze Orman tells me a &quot;budget&quot; is like a &quot;diet&quot; for money.  I feel enlightened.',NULL,NULL,'status','FacebookActivityStreamItem',1),(88,1245860623,1247463029,'2009-06-24 16:23:43',NULL,'funny as hell','--- \nhref: http://www.facebook.com/ext/share.php?sid=94755871589&amp;h=Tl2hj&amp;u=mJI1n\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47ed67f229dfe2caec6c5e7ee58a1ccc&amp;url=http%3A%2F%2Ftrueslant.com%2Frachelking%2Ffiles%2F2009%2F06%2F300px-virgin_america_a320_cabin.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(89,1245881524,1247463029,'2009-06-24 22:12:04',NULL,'So John McCain thinks the president should have responded more harshly to the situation in Iran.  However, from this article: &quot;at the Republican National Committee convention in St. Paul in 2004,  250 protesters were arrested shortly before John McCain took the podium. Most were innocent activists and even journalists.&quot;  What a hypocrite.','--- \nname: \"Informed Comment: Washington and the Iran Protests:\"\nhref: http://www.facebook.com/ext/share.php?sid=94997638190&amp;h=ZKuZX&amp;u=Q-QYw\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.juancole.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1),(90,1245945530,1247463030,'2009-06-25 15:58:50',NULL,'they need to teach a class in facebook etiquette',NULL,NULL,'status','FacebookActivityStreamItem',1),(91,1245946351,1247463030,'2009-06-25 16:12:31',NULL,'wow, this is a REAL advertisement for IE8???  WOWOWOWOWO','--- \nhref: http://www.facebook.com/ext/share.php?sid=95526323542&amp;h=wEa1o&amp;u=oYcUG\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3379b4a491cbb4732a88173f1e5ca83d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F8-9Mjm-Hohc%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=95526323542#s95526323542\n  source_url: http://www.youtube.com/v/8-9Mjm-Hohc&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=8-9Mjm-Hohc&amp;eurl=http://gizmodo.com/5302248/dean-cain-wards-off-puke-and-porn-with-internet-explorer-8-nsfl&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: O.M.G.I.G.P. - Internet Explorer 8\n','video','post','FacebookActivityStreamItem',1),(92,1245946632,1247463030,'2009-06-25 16:17:12',NULL,'wants a Cabybara.  Winner to get the first reference to this rodents name (Caplin Rous)','--- \nhref: http://www.facebook.com/ext/share.php?sid=101192687115&amp;h=uRE9J&amp;u=kqO3K\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7471338a4ffea137061bef8544be0028&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3618%2F3658068677_52d3857f02.jpg%3Fv%3D0&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(93,1245948225,1247463030,'2009-06-25 16:43:45',NULL,'RIP Farrah Fawcet',NULL,NULL,'status','FacebookActivityStreamItem',1),(94,1245953519,1247463030,'2009-06-25 18:11:59',NULL,'Ed Macmahon... Farrah Fawcet... Patrik Swayze next?',NULL,NULL,'status','FacebookActivityStreamItem',1),(95,1245966308,1247463030,'2009-06-25 21:45:08',NULL,'http://www.tmz.com/2009/06/25/michael-jackson-dies-death-dead-cardiac-arrest/','--- \nhref: http://www.facebook.com/ext/share.php?sid=97219678547&amp;h=E5Abt&amp;u=Yio4N\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d98fc22bca4166f2d2ff9d12eccc7a97&amp;url=http%3A%2F%2Fwww.blogcdn.com%2Fwww.tmz.com%2Fmedia%2F2009%2F06%2F0625_michael_jackson_ex2.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(96,1245967990,1247463030,'2009-06-25 22:13:10',NULL,'TMZ typically breaks news in advance because they have people on every LA area hospital.  More reputable organizations do not engage in those type of practices.  Despite the ethics, I am 99% sure TMZ is right here, and people at CNN and FOX should at LEAST report that TMZ is reporting rather than BLATANTLY ignoring that report.',NULL,NULL,'status','FacebookActivityStreamItem',1),(97,1245968597,1247463030,'2009-06-25 22:23:17',NULL,'LA TIMES CONFIRMS MJ IS DEAD','--- \nhref: http://www.facebook.com/ext/share.php?sid=108375399592&amp;h=6FZlx&amp;u=8k_0P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=04659cdefc877c7febbce3f425ff959c&amp;url=http%3A%2F%2Flatimesblogs.latimes.com%2Flanow%2Fktla-logo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(98,1245981437,1247463030,'2009-06-26 01:57:17',NULL,'OMG.  Jeff Goldblum is NOT dead.  Knock it off.',NULL,NULL,'status','FacebookActivityStreamItem',1),(99,1246023511,1247463030,'2009-06-26 13:38:31',NULL,'neat stuff here *thanks sean*','--- \nhref: http://www.facebook.com/ext/share.php?sid=95716179033&amp;h=VRnq_&amp;u=m7d15\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=340bf8dd95f6f5f814cb8ee0e2012458&amp;url=http%3A%2F%2Fwww.webdesignerdepot.com%2Fwp-content%2Fuploads%2Fphoto_manipulation%2Fphoto_manipulation.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(100,1246026362,1247463030,'2009-06-26 14:26:02',NULL,'think you gotta know me pretty well to understand this one','--- \nhref: http://www.facebook.com/ext/share.php?sid=97434442218&amp;h=II1iR&amp;u=8Xt45\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=738662a89784f4fdb4418ce8bdaae1d0&amp;url=http%3A%2F%2Fi.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17531%2Fjloh_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(101,1246043515,1247463030,'2009-06-26 19:11:55',NULL,'Good Stuff!','--- \nhref: http://www.facebook.com/ext/share.php?sid=92521878203&amp;h=WS4Cy&amp;u=4xyOv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=db3c2fc87743b6d992afe575e75b2230&amp;url=http%3A%2F%2Fwww.dailygalaxy.com%2F.a%2F6a00d8341bf7f753ef011571591c67970b-500wi&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(102,1246044169,1247463030,'2009-06-26 19:22:49',NULL,'just got out of court.  I won and Jack is going to HAWAII with us in six days!  Thanks everyone for their support!',NULL,NULL,'status','FacebookActivityStreamItem',1),(103,1246062670,1247463030,'2009-06-27 00:31:10',NULL,'just finished the [Frostbitten] achievement!',NULL,NULL,'status','FacebookActivityStreamItem',1),(104,1246124462,1247463030,'2009-06-27 17:41:02',NULL,'ouch  ouch   ouch  my head  ouch',NULL,NULL,'status','FacebookActivityStreamItem',1),(105,1246169526,1247463030,'2009-06-28 06:12:06',NULL,'oh.. the irony...','--- \nhref: http://www.facebook.com/ext/share.php?sid=95666789393&amp;h=0zkuq&amp;u=jHsHt\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ea8a6ede06cbc087a42220dab7647307&amp;url=http%3A%2F%2Fwww.sfscope.com%2F2009%2F05%2Funthinkable3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(106,1246226191,1247463030,'2009-06-28 21:56:31',NULL,'preparing for Hawaii is stressful!  Getting to Hawaii will be peaceful!',NULL,NULL,'status','FacebookActivityStreamItem',1),(107,1246252220,1247463030,'2009-06-29 05:10:20',NULL,'okay guys, I hate to say it... Carradine, Fawcet, McMahon, Jackson, Mays... we are in the midst of a major celebrity pruning...  I am voting for Swayze next... who else do you think is going to kick the bucket?  Vote now!',NULL,NULL,'status','FacebookActivityStreamItem',1),(108,1246289099,1247463030,'2009-06-29 15:24:59',NULL,'this was an AMAZING Rolling Stone Article about Goldman Sachs, not available online until this guy put it online.  What a read.  Amazing, MUST read story!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=96830267916&amp;h=9vJPR&amp;u=Dv7Mh\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c989b8093c9356aa494848c030f4d4cc&amp;url=http%3A%2F%2Ffi.somethingawful.com%2Fcustomtitles%2Ftitle-paper_mac.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(109,1246309479,1247463031,'2009-06-29 21:04:39',NULL,'just heard a good one... &quot;Billy Mays heard that celebrities die in threes... leave it up to him to throw in an extra for free!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1),(110,1246342950,1247463031,'2009-06-30 06:22:30',NULL,'skepticism is a good thing :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=109998674416&amp;h=fpYxP&amp;u=UhTuB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6c0f9134ad5b251f4bab2595864e8836&amp;url=http%3A%2F%2Fwww.quarrygirl.com%2Fwp-content%2Fuploads%2F2009%2F06%2Flotus-vegan-tests-570x214.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(111,1246383230,1247463031,'2009-06-30 17:33:50',NULL,'I\'ll take two','--- \nhref: http://www.facebook.com/ext/share.php?sid=135338090048&amp;h=gTW7A&amp;u=G7y4t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b4f49c2a5dca9c39a46d3f473150d8a&amp;url=http%3A%2F%2Fwww.blogsmithcdn.com%2Favatar%2Fimages%2F8%2F2706050_64.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(112,1246383422,1247463031,'2009-06-30 17:37:02',NULL,'where we are staying in Maui, plane leaves in 48 hours!','--- \nhref: http://www.facebook.com/ext/share.php?sid=97812617481&amp;h=me28P&amp;u=cyYJ6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ab692551e934f6ec09b7dde55a258de0&amp;url=http%3A%2F%2Fwww.vacationrentalagent.com%2Fimages%2Frentals%2Fp2648_i9_1138229661.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(113,1246401333,1247463031,'2009-06-30 22:35:33',NULL,'is leaving on a jet plane...',NULL,NULL,'status','FacebookActivityStreamItem',1),(114,1246488683,1247463031,'2009-07-01 22:51:23',NULL,'on the ferry to go pick up my son for our trip to hawaii. I haven\'t seen him in 24 days, I\'m shaking with excitement!!',NULL,NULL,'status','FacebookActivityStreamItem',1),(115,1246491025,1247463031,'2009-07-01 23:30:25',NULL,'does anyone else have a problem in the case that you advance pay for a service (cell phone minutes, gift cards, transportaion like ferry tickets) and they \'expire\' in 90 days with no possible refund?  How can something digital \'expire\'?  Theivery more like it.',NULL,NULL,'status','FacebookActivityStreamItem',1),(116,1246505431,1247463031,'2009-07-02 03:30:31',NULL,'yep.  the last will of Michael Jackson, scanned in entirety','--- \nhref: http://www.facebook.com/ext/share.php?sid=130220558664&amp;h=97Euj&amp;u=IYsYS\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b5de2be5d3e47de2092b8240eb8bfa3&amp;url=http%3A%2F%2Fimg.docstoc.com%2Fthumb%2F100%2F8016703.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(117,1246550214,1247463031,'2009-07-02 15:56:54',NULL,'this is what I plan to do in Hawaii..','--- \nhref: http://www.facebook.com/ext/share.php?sid=98896998621&amp;h=73l62&amp;u=U6W3T\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f190d45c088f8c836091b2c5abdd7ad6&amp;url=http%3A%2F%2Fmarkmathews.files.wordpress.com%2F2009%2F06%2Fdsc_9802.jpg%3Fw%3D500%26h%3D333&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1),(118,1246563034,1247463031,'2009-07-02 19:30:34',NULL,'very inspiring...  (mr. jobs has been my hero since I was 11 years old)','--- \nhref: http://www.facebook.com/ext/share.php?sid=94776700767&amp;h=W8bvv&amp;u=GNsr7\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=5da65e9dc881c8fc6152dc531d6b468d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FD1R-jKKp3NA%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=94776700767#s94776700767\n  source_url: http://www.youtube.com/v/D1R-jKKp3NA&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=D1R-jKKp3NA\n  owner: \"504883639\"\nalt: Steve Jobs Stanford Commencement Speech 2005\n','video','post','FacebookActivityStreamItem',1),(119,1246565446,1247463031,'2009-07-02 20:10:46',NULL,'is heading to Hawaii with the kids at 2:40 today!!  Packed and ready to go.  I really dislike flying!!!  Robin heads out a day later and is flying first class sans kiddos, lucky her!',NULL,NULL,'status','FacebookActivityStreamItem',1),(120,1246642731,1247463031,'2009-07-03 17:38:51',NULL,'what is better than seeing both your kids sit up bolt upright in bed and in unison say &quot;HAWAII!!  LETS GO SWIMMING!!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1),(121,1246651209,1247463031,'2009-07-03 20:00:09',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2016963&amp;id=504883639\nphoto: \n  pid: \"2168458717792487107\"\n  aid: \"2168458717790500067\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97226283639_504883639_2016963_17468_s.jpg\ntype: photo\nalt: {}\n\n','photo','post','FacebookActivityStreamItem',1),(122,1246762402,1247463031,'2009-07-05 02:53:22',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2023666&amp;id=504883639\nphoto: \n  pid: \"2168458717792493810\"\n  aid: \"2168458717790559128\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659613639_504883639_2023666_3645362_s.jpg\ntype: photo\nalt: IMG_1246\n','photo','post','FacebookActivityStreamItem',1),(123,1246991032,1247463031,'2009-07-07 18:23:52',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045780&amp;id=504883639\nphoto: \n  pid: \"2168458717792515924\"\n  aid: \"2168458717790559781\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712603639_504883639_2045780_6002293_s.jpg\ntype: photo\nalt: IMG_1284\n','photo','post','FacebookActivityStreamItem',1),(124,1246991082,1247463031,'2009-07-07 18:24:42',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045797&amp;id=504883639\nphoto: \n  pid: \"2168458717792515941\"\n  aid: \"2168458717790559782\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2045797_3936659.jpg\ntype: photo\nalt: IMG_1324\n','photo','post','FacebookActivityStreamItem',1),(125,1246991356,1247463031,'2009-07-07 18:29:16',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045818&amp;id=504883639\nphoto: \n  pid: \"2168458717792515962\"\n  aid: \"2168458717790559785\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714653639_504883639_2045818_2842033_s.jpg\ntype: photo\nalt: IMG_2305\n','photo','post','FacebookActivityStreamItem',1),(126,1247014071,1247463031,'2009-07-08 00:47:51',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047298&amp;id=504883639\nphoto: \n  pid: \"2168458717792517442\"\n  aid: \"2168458717790559838\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835568639_504883639_2047298_5035742_s.jpg\ntype: photo\nalt: IMG_1341\n','photo','post','FacebookActivityStreamItem',1),(127,1247016009,1247463031,'2009-07-08 01:20:09',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047415&amp;id=504883639\nphoto: \n  pid: \"2168458717792517559\"\n  aid: \"2168458717790559844\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2047415_6779141.jpg\ntype: photo\nalt: IMG_2359\n','photo','post','FacebookActivityStreamItem',1),(128,1247046267,1247463031,'2009-07-08 09:44:27',NULL,'can\'t even begin to describe the love and affection for my fam, my new one with Jack and Lena and Robin, and my old one with Trev, Keenan, Ryan and Mima!',NULL,NULL,'status','FacebookActivityStreamItem',1),(129,1247089147,1247463031,'2009-07-08 21:39:07',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2051914&amp;id=504883639\nphoto: \n  pid: \"2168458717792522058\"\n  aid: \"2168458717790560009\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164403639_504883639_2051914_3841018_s.jpg\ntype: photo\nalt: IMG_2429\n','photo','post','FacebookActivityStreamItem',1),(130,1247125765,1247463031,'2009-07-09 07:49:25',NULL,'just dropped off Robin and Lena at the airport... one more day in Maui then back to ... reality, oh noes!',NULL,NULL,'status','FacebookActivityStreamItem',1),(131,1247173917,1247463031,'2009-07-09 21:11:57',NULL,'is dreading his flight home.  When are scientists going to invent a matter transportation / teleportation device.  I\'d pay double.',NULL,NULL,'status','FacebookActivityStreamItem',1),(132,1247183849,1247463032,'2009-07-09 23:57:29',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2057974&amp;id=504883639\nphoto: \n  pid: \"2168458717792528118\"\n  aid: \"2168458717790560214\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591663639_504883639_2057974_4968127_s.jpg\ntype: photo\nalt: IMG_1386\n','photo','post','FacebookActivityStreamItem',1),(133,1247183985,1247463032,'2009-07-09 23:59:45',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2058002&amp;id=504883639\nphoto: \n  pid: \"2168458717792528146\"\n  aid: \"2168458717790560215\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592463639_504883639_2058002_1414467_s.jpg\ntype: photo\nalt: IMG_2479\n','photo','post','FacebookActivityStreamItem',1),(134,1247184663,1247463032,'2009-07-10 00:11:03',NULL,'Last day in Hawaii and looking very very tan :)','--- \nhref: http://www.facebook.com/photo.php?pid=2058068&amp;id=504883639\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593833639_504883639_2058068_5149723_s.jpg\ntype: link\n','link','post','FacebookActivityStreamItem',1),(135,1247232179,1247463032,'2009-07-10 13:22:59',NULL,'ouch. Back in Seattle on a redeye I didn\'t sleep on. Jet lag will suck for a couple days. Today especially. I\'ll be around but napping till hopefully I get fully adjusted tomorrow. Got to see my girls this morning and that is great!!!',NULL,NULL,'status','FacebookActivityStreamItem',1),(136,1247268133,1247463032,'2009-07-10 23:22:13',NULL,'rested, still a little jet lagged, trying to catch up, plan to be putting in 14 hour days till I\'m back on pace.',NULL,NULL,'status','FacebookActivityStreamItem',1),(137,1247271899,1247463032,'2009-07-11 00:24:59',NULL,'OMG ROFLMOA!','--- \nname: Morgan Spurlock\'s Experiment To Try Heroin For 30 Days Enters 200th Day | The Onion - America\'s Fine\nhref: http://www.facebook.com/ext/share.php?sid=96378168341&amp;h=oGqAq&amp;u=lAx8b\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/news.gif?8:25796\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\ndescription: files/radionews/06-192 Morgan Spurlock _F.mp3\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1),(138,1247344634,1247463032,'2009-07-11 20:37:14',NULL,'West Seattle Street Fair and 85 degrees.  Good times!',NULL,NULL,'status','FacebookActivityStreamItem',1),(139,1247372553,1247463032,'2009-07-12 04:22:33',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2070133&amp;id=504883639\nphoto: \n  pid: \"2168458717792540277\"\n  aid: \"2168458717790560616\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_100385838639_504883639_2070133_4101049_s.jpg\ntype: photo\nalt: IMG_0496\n','photo','post','FacebookActivityStreamItem',1),(140,1247433193,1247463032,'2009-07-12 21:13:13',NULL,'Home plate seats!!','--- \nhref: http://www.facebook.com/photo.php?pid=2075720&amp;id=504883639\nphoto: \n  pid: \"2168458717792545864\"\n  aid: \"2168458717790500067\"\n  index: \"1\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_100641573639_504883639_2075720_8038526_s.jpg\ntype: photo\nalt: Home plate seats!!\n','photo','post','FacebookActivityStreamItem',1),(141,1247459838,1247463032,'2009-07-13 04:37:18',NULL,'sneezing',NULL,NULL,'status','FacebookActivityStreamItem',1);
/*!40000 ALTER TABLE `activity_stream_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_streams`
--

DROP TABLE IF EXISTS `activity_streams`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `activity_streams` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `last_activity_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_activity_streams_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `activity_streams`
--

LOCK TABLES `activity_streams` WRITE;
/*!40000 ALTER TABLE `activity_streams` DISABLE KEYS */;
INSERT INTO `activity_streams` VALUES (1,1,NULL);
/*!40000 ALTER TABLE `activity_streams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address_books`
--

DROP TABLE IF EXISTS `address_books`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `address_books` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `icq` varchar(255) default NULL,
  `skype` varchar(255) default NULL,
  `msn` varchar(255) default NULL,
  `aol` varchar(255) default NULL,
  `ssn_b` blob,
  `birthdate` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `middle_name` varchar(255) default NULL,
  `name_suffix` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `timezone` varchar(255) default NULL,
  `photo_file_name` varchar(255) default NULL,
  `photo_content_type` varchar(255) default NULL,
  `photo_file_size` int(11) default NULL,
  `photo_updated_at` datetime default NULL,
  `name_title` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_address_books_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `address_books`
--

LOCK TABLES `address_books` WRITE;
/*!40000 ALTER TABLE `address_books` DISABLE KEYS */;
INSERT INTO `address_books` VALUES (1,1,'Hermann','Adams',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 05:27:32','2009-07-13 05:27:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `address_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL auto_increment,
  `addressable_id` int(11) default NULL,
  `addressable_type` varchar(255) default NULL,
  `location_type` varchar(255) NOT NULL,
  `street_2` varchar(255) default NULL,
  `region_id` int(11) default NULL,
  `country_id` int(11) default NULL,
  `custom_region` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `street_1` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(255) NOT NULL,
  `user_id` int(11) default NULL,
  `moved_out_on` date default NULL,
  `moved_in_on` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_addresses_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `albums` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `av_attachments`
--

DROP TABLE IF EXISTS `av_attachments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `av_attachments` (
  `id` int(11) NOT NULL auto_increment,
  `av_attachable_id` int(11) default NULL,
  `av_attachable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `recording_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `av_attachments`
--

LOCK TABLES `av_attachments` WRITE;
/*!40000 ALTER TABLE `av_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `av_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_emails`
--

DROP TABLE IF EXISTS `backup_emails`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_emails` (
  `id` int(11) NOT NULL auto_increment,
  `backup_source_id` int(11) NOT NULL,
  `message_id` varchar(255) default NULL,
  `subject` varchar(255) default NULL,
  `sender` varchar(255) default NULL,
  `received_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_emails_on_backup_source_id` (`backup_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_emails`
--

LOCK TABLES `backup_emails` WRITE;
/*!40000 ALTER TABLE `backup_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_job_archives`
--

DROP TABLE IF EXISTS `backup_job_archives`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_job_archives` (
  `id` int(11) NOT NULL auto_increment,
  `started_at` datetime default NULL,
  `finished_at` datetime default NULL,
  `status_id` int(11) default NULL,
  `size` int(11) default NULL,
  `messages` text,
  `user_id` int(11) default NULL,
  `error_messages` text,
  PRIMARY KEY  (`id`),
  KEY `finished_at` (`finished_at`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_job_archives`
--

LOCK TABLES `backup_job_archives` WRITE;
/*!40000 ALTER TABLE `backup_job_archives` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_job_archives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_jobs`
--

DROP TABLE IF EXISTS `backup_jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `percent_complete` int(11) default NULL,
  `size` int(11) default NULL,
  `status` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `cancelled` tinyint(1) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `finished_at` datetime default NULL,
  `error_messages` text,
  PRIMARY KEY  (`id`),
  KEY `index_backup_jobs_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_jobs`
--

LOCK TABLES `backup_jobs` WRITE;
/*!40000 ALTER TABLE `backup_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_photo_albums`
--

DROP TABLE IF EXISTS `backup_photo_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_photo_albums` (
  `id` int(11) NOT NULL auto_increment,
  `backup_source_id` int(11) NOT NULL,
  `source_album_id` varchar(255) NOT NULL,
  `cover_id` varchar(255) NOT NULL,
  `size` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `location` varchar(255) default NULL,
  `modified` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_photo_albums_on_backup_source_id` (`backup_source_id`),
  KEY `index_backup_photo_albums_on_source_album_id` (`source_album_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_photo_albums`
--

LOCK TABLES `backup_photo_albums` WRITE;
/*!40000 ALTER TABLE `backup_photo_albums` DISABLE KEYS */;
INSERT INTO `backup_photo_albums` VALUES (1,1,'2168458722085437437','2168458717792516589',16,'Profile Pictures','','2009-07-13 05:27:41','2009-07-13 05:27:41','','1246998729'),(2,1,'2168458717790500067','2168458717792545864',19,'Mobile Uploads','','2009-07-13 05:27:44','2009-07-13 05:27:44','','1247433192'),(3,1,'2168458717790560616','2168458717792540276',2,'Last Import','','2009-07-13 05:27:47','2009-07-13 05:27:47','','1247372554'),(4,1,'2168458717790560215','2168458717792528144',72,'Jul 9, 2009','','2009-07-13 05:27:52','2009-07-13 05:27:52','','1247188013'),(5,1,'2168458717790560214','2168458717792528116',26,'Hawaii 2009','','2009-07-13 05:27:57','2009-07-13 05:27:57','','1247269149'),(6,1,'2168458717790560009','2168458717792522056',33,'Hawaii 2009 - Mom\'s Camera','','2009-07-13 05:28:01','2009-07-13 05:28:01','','1247089301'),(7,1,'2168458717790559844','2168458717792517557',27,'Hawaii 2009','','2009-07-13 05:28:05','2009-07-13 05:28:05','','1247016115'),(8,1,'2168458717790559838','2168458717792517440',35,'Hawaii 2009','','2009-07-13 05:28:09','2009-07-13 05:28:09','','1247014161'),(9,1,'2168458717790559785','2168458717792515960',39,'Hawaii 2009 - Mom\'s Camera','','2009-07-13 05:28:14','2009-07-13 05:28:14','','1246991513'),(10,1,'2168458717790559782','2168458717792515937',14,'Jul 6, 2009','','2009-07-13 05:28:17','2009-07-13 05:28:17','','1246991131'),(11,1,'2168458717790559781','2168458717792515922',12,'Hawaii 2009','','2009-07-13 05:28:20','2009-07-13 05:28:20','','1246991059'),(12,1,'2168458717790559128','2168458717792493808',32,'Hawaii 2009','','2009-07-13 05:28:24','2009-07-13 05:28:24','','1246763230'),(13,1,'2168458717790556751','2168458717792430501',1,'robin','','2009-07-13 05:28:27','2009-07-13 05:28:27','','1245799420'),(14,1,'2168458717790556513','2168458717792423010',31,'Old Pics','','2009-07-13 05:28:31','2009-07-13 05:28:31','','1245699950'),(15,1,'2168458717790556509','2168458717792422967',15,'Fathers Day 2009','','2009-07-13 05:28:34','2009-07-13 05:28:34','','1245699061'),(16,1,'2168458717790555233','2168458717792387143',3,'Aug 1, 2007','','2009-07-13 05:28:37','2009-07-13 05:28:37','','1245138310'),(17,1,'2168458717790552261','2168458717792313288',6,'May 30, 2009','','2009-07-13 05:28:39','2009-07-13 05:28:39','','1243840732'),(18,1,'2168458717790552260','2168458717792313276',8,'Teeball','','2009-07-13 05:28:42','2009-07-13 05:28:42','','1243840547'),(19,1,'2168458717790550922','2168458717792280708',2,'Memorial Day','','2009-07-13 05:28:45','2009-07-13 05:28:45','','1243211851'),(20,1,'2168458717790549528','2168458717792245666',1,'Beach Day with Uncle Trev','','2009-07-13 05:28:47','2009-07-13 05:28:47','','1242600480'),(21,1,'2168458717790549524','2168458717792245591',20,'Beach Day with Uncle Trev','','2009-07-13 05:28:50','2009-07-13 05:28:50','','1242600193'),(22,1,'2168458717790547785','2168458717792205620',6,'Robin Fairmont Site Pics','','2009-07-13 05:28:53','2009-07-13 05:28:53','','1241818149'),(23,1,'2168458717790545840','2168458717792161830',1,'Nov 3, 2007','','2009-07-13 05:28:55','2009-07-13 05:28:55','','1240938371'),(24,1,'2168458717790544072','2168458717792123626',1,'Kareoke','','2009-07-13 05:28:58','2009-07-13 05:28:58','','1240162004'),(25,1,'2168458717790542581','2168458717792090624',24,'April 2009','','2009-07-13 05:29:01','2009-07-13 05:29:01','','1239560563'),(26,1,'2168458717790540006','2168458717792032931',5,'Mar 28, 2009','','2009-07-13 05:29:04','2009-07-13 05:29:04','','1238293010'),(27,1,'2168458717790505965','2168458717791299482',18,'Burning Man 2008','','2009-07-13 05:29:07','2009-07-13 05:29:07','Black Rock Desert','1238207989'),(28,1,'2168458717790536453','2168458717791956112',4,'My Dad as a Kid','','2009-07-13 05:29:10','2009-07-13 05:29:10','','1236614193'),(29,1,'2168458717790535903','2168458717791943969',3,'Jack Weekend March 06 2009','','2009-07-13 05:29:12','2009-07-13 05:29:12','','1236367642'),(30,1,'2168458717790535737','2168458717791940784',4,'Old Scanned Photos','','2009-07-13 05:29:15','2009-07-13 05:29:15','','1236286370'),(31,1,'2168458717790534817','2168458717791919965',18,'February 2009 - End','','2009-07-13 05:29:18','2009-07-13 05:29:18','','1235894458'),(32,1,'2168458717790533166','2168458717791887397',12,'Mar 23, 2008','','2009-07-13 05:29:21','2009-07-13 05:29:21','','1235111348'),(33,1,'2168458717790533157','2168458717791887197',15,'Nov 28, 2007','','2009-07-13 05:29:24','2009-07-13 05:29:24','','1235106431'),(34,1,'2168458717790533162','2168458717791887306',7,'Serena\'s Wedding','','2009-07-13 05:29:27','2009-07-13 05:29:27','','1235106387'),(35,1,'2168458717790533159','2168458717791887237',60,'Legoland 2007','','2009-07-13 05:29:31','2009-07-13 05:29:31','','1235106112'),(36,1,'2168458717790533160','2168458717791887271',1,'Dec 8, 2007','','2009-07-13 05:29:35','2009-07-13 05:29:35','','1235105718'),(37,1,'2168458717790533137','2168458717791886828',26,'February 18th','','2009-07-13 05:29:38','2009-07-13 05:29:38','','1235096601'),(38,1,'2168458717790533125','2168458717791886579',23,'Feb 13-19th, 2009','','2009-07-13 05:29:42','2009-07-13 05:29:42','','1235094078'),(39,1,'2168458717790531717','2168458717791856983',4,'Feb 8, 2009','','2009-07-13 05:29:45','2009-07-13 05:29:45','','1234396203'),(40,1,'2168458717790528923','2168458717791798566',2,'Sep 21, 2008','','2009-07-13 05:29:47','2009-07-13 05:29:47','Jeep Accident','1233195057'),(41,1,'2168458717790527242','2168458717791763218',33,'Whistler 2009!','','2009-07-13 05:29:51','2009-07-13 05:29:51','whistler, canada','1232437025'),(42,1,'2168458717790526044','2168458717791736987',11,'Bowling and Skating Day','','2009-07-13 05:29:54','2009-07-13 05:29:54','Lynnwood','1231881246'),(43,1,'2168458717790521634','2168458717791638090',3,'Snow Day 2008','','2009-07-13 05:29:57','2009-07-13 05:29:57','Vashon Island','1230018630'),(44,1,'2168458717790517869','2168458717791560985',18,'Some New Pics','','2009-07-13 05:29:59','2009-07-13 05:29:59','','1229025019'),(45,1,'2168458717790517526','2168458717791554187',2,'Thanksgiving 2008','','2009-07-13 05:30:02','2009-07-13 05:30:02','','1227832088'),(46,1,'2168458717790513271','2168458717791463675',8,'Halloween 2008','','2009-07-13 05:30:05','2009-07-13 05:30:05','','1225557309'),(47,1,'2168458717790513181','2168458717791461811',1,'Old High School Pics','','2009-07-13 05:30:08','2009-07-13 05:30:08','','1225511339');
/*!40000 ALTER TABLE `backup_photo_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_photos`
--

DROP TABLE IF EXISTS `backup_photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_photos` (
  `id` int(11) NOT NULL auto_increment,
  `backup_photo_album_id` int(11) NOT NULL,
  `source_photo_id` varchar(255) NOT NULL,
  `content_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `source_url` text,
  `caption` varchar(255) default NULL,
  `tags` varchar(255) default NULL,
  `downloaded` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_backup_photos_on_backup_photo_album_id` (`backup_photo_album_id`),
  KEY `index_backup_photos_on_source_photo_id` (`source_photo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=725 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_photos`
--

LOCK TABLES `backup_photos` WRITE;
/*!40000 ALTER TABLE `backup_photos` DISABLE KEYS */;
INSERT INTO `backup_photos` VALUES (1,1,'2168458717792516589',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98759248639_504883639_2046445_6979542_n.jpg','','--- \n- Robin Schauer\n',0),(2,1,'2168458717792436577',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_94047673639_504883639_1966433_2506094_n.jpg','',NULL,0),(3,1,'2168458717792430683',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93632468639_504883639_1960539_5626101_n.jpg','',NULL,0),(4,1,'2168458717792402321',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs112.snc1/5117_91760733639_504883639_1932177_1585236_n.jpg','',NULL,0),(5,1,'2168458717792182798',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs007.snc1/2839_76707018639_504883639_1712654_585655_n.jpg','',NULL,0),(6,1,'2168458717792083208',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1613064_3835677.jpg','',NULL,0),(7,1,'2168458717792032944',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2620/77/120/504883639/n504883639_1562800_20745.jpg','',NULL,0),(8,1,'2168458717792032937',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2620/77/120/504883639/n504883639_1562793_4573529.jpg','',NULL,0),(9,1,'2168458717791923606',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1453462_3151192.jpg','',NULL,0),(10,1,'2168458717791803912',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1333768_5585.jpg','',NULL,0),(11,1,'2168458717791599701',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v1057/77/120/504883639/n504883639_1129557_6645.jpg','',NULL,0),(12,1,'2168458717791075310',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v272/77/120/504883639/n504883639_605166_3913.jpg','',NULL,0),(13,1,'2168458717791075313',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v255/77/120/504883639/n504883639_605169_4889.jpg','',NULL,0),(14,1,'2168458717791075312',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v255/77/120/504883639/n504883639_605168_4064.jpg','',NULL,0),(15,1,'2168458717791075311',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v255/77/120/504883639/n504883639_605167_7561.jpg','',NULL,0),(16,1,'2168458717790500550',NULL,'2009-07-13 05:27:41','2009-07-13 05:27:41','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v67/77/120/504883639/n504883639_30406_5210.jpg','',NULL,0),(17,2,'2168458717792545864',NULL,'2009-07-13 05:27:44','2009-07-13 05:27:44','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_100641573639_504883639_2075720_8038526_n.jpg','Home plate seats!!',NULL,0),(18,2,'2168458717792487107',NULL,'2009-07-13 05:27:44','2009-07-13 05:27:44','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97226283639_504883639_2016963_17468_n.jpg','',NULL,0),(19,2,'2168458717791889728',NULL,'2009-07-13 05:27:44','2009-07-13 05:27:44','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1419584_451.jpg','Dazed and confused',NULL,0),(20,2,'2168458717791654587',NULL,'2009-07-13 05:27:44','2009-07-13 05:27:44','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1184443_2003.jpg','',NULL,0),(21,2,'2168458717791654585',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1184441_5677.jpg','',NULL,0),(22,2,'2168458717791654584',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1184440_9605.jpg','',NULL,0),(23,2,'2168458717791554224',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1084080_8965.jpg','',NULL,0),(24,2,'2168458717791328098',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_857954_9083.jpg','',NULL,0),(25,2,'2168458717791289161',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_819017_7705.jpg','',NULL,0),(26,2,'2168458717791288783',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_818639_4168.jpg','',NULL,0),(27,2,'2168458717791287467',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_817323_3239.jpg','',NULL,0),(28,2,'2168458717791253844',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_783700_3230.jpg','',NULL,0),(29,2,'2168458717791253820',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_783676_6712.jpg','',NULL,0),(30,2,'2168458717791249760',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_779616_5774.jpg','',NULL,0),(31,2,'2168458717791167095',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v300/77/120/504883639/n504883639_696951_6780.jpg','',NULL,0),(32,2,'2168458717791166861',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v300/77/120/504883639/n504883639_696717_9162.jpg','',NULL,0),(33,2,'2168458717791166860',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v300/77/120/504883639/n504883639_696716_4640.jpg','',NULL,0),(34,2,'2168458717791166859',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v300/77/120/504883639/n504883639_696715_4848.jpg','',NULL,0),(35,2,'2168458717791166843',NULL,'2009-07-13 05:27:45','2009-07-13 05:27:45','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v300/77/120/504883639/n504883639_696699_8062.jpg','',NULL,0),(36,3,'2168458717792540276',NULL,'2009-07-13 05:27:47','2009-07-13 05:27:47','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_100385823639_504883639_2070132_8192667_n.jpg','IMG_0495',NULL,0),(37,3,'2168458717792540277',NULL,'2009-07-13 05:27:47','2009-07-13 05:27:47','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_100385838639_504883639_2070133_4101049_n.jpg','IMG_0496',NULL,0),(38,4,'2168458717792528144',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592438639_504883639_2058000_6931855_n.jpg','IMG_2477',NULL,0),(39,4,'2168458717792528145',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592453639_504883639_2058001_1920631_n.jpg','IMG_2478',NULL,0),(40,4,'2168458717792528146',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592463639_504883639_2058002_1414467_n.jpg','IMG_2479',NULL,0),(41,4,'2168458717792528147',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592478639_504883639_2058003_417324_n.jpg','IMG_2480',NULL,0),(42,4,'2168458717792528148',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592498639_504883639_2058004_5913409_n.jpg','IMG_2483',NULL,0),(43,4,'2168458717792528149',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592518639_504883639_2058005_3692009_n.jpg','IMG_2484',NULL,0),(44,4,'2168458717792528150',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592538639_504883639_2058006_3767567_n.jpg','IMG_2485',NULL,0),(45,4,'2168458717792528151',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592588639_504883639_2058007_1662427_n.jpg','IMG_2486',NULL,0),(46,4,'2168458717792528152',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592608639_504883639_2058008_1604007_n.jpg','IMG_2487',NULL,0),(47,4,'2168458717792528153',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592633639_504883639_2058009_5725700_n.jpg','IMG_2488',NULL,0),(48,4,'2168458717792528155',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592658639_504883639_2058011_3430591_n.jpg','IMG_2489',NULL,0),(49,4,'2168458717792528156',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592678639_504883639_2058012_2548868_n.jpg','IMG_2490',NULL,0),(50,4,'2168458717792528157',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592698639_504883639_2058013_7617851_n.jpg','IMG_2491',NULL,0),(51,4,'2168458717792528158',NULL,'2009-07-13 05:27:52','2009-07-13 05:27:52','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592723639_504883639_2058014_1294058_n.jpg','IMG_2492',NULL,0),(52,4,'2168458717792528159',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592738639_504883639_2058015_1520765_n.jpg','IMG_2493',NULL,0),(53,4,'2168458717792528160',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592753639_504883639_2058016_3294306_n.jpg','IMG_2494',NULL,0),(54,4,'2168458717792528161',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592768639_504883639_2058017_4261639_n.jpg','IMG_2495',NULL,0),(55,4,'2168458717792528162',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592783639_504883639_2058018_145451_n.jpg','IMG_2496',NULL,0),(56,4,'2168458717792528163',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592798639_504883639_2058019_6613040_n.jpg','IMG_2497',NULL,0),(57,4,'2168458717792528164',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592823639_504883639_2058020_2549955_n.jpg','IMG_2498',NULL,0),(58,4,'2168458717792528165',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592843639_504883639_2058021_4654239_n.jpg','IMG_2499',NULL,0),(59,4,'2168458717792528166',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592858639_504883639_2058022_6372727_n.jpg','IMG_2500',NULL,0),(60,4,'2168458717792528167',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592883639_504883639_2058023_2521540_n.jpg','IMG_2501',NULL,0),(61,4,'2168458717792528168',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592898639_504883639_2058024_2810353_n.jpg','IMG_2502',NULL,0),(62,4,'2168458717792528169',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592913639_504883639_2058025_2996345_n.jpg','IMG_2503',NULL,0),(63,4,'2168458717792528170',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592933639_504883639_2058026_4237215_n.jpg','IMG_2504',NULL,0),(64,4,'2168458717792528171',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592953639_504883639_2058027_6540475_n.jpg','IMG_2505',NULL,0),(65,4,'2168458717792528172',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592978639_504883639_2058028_2225635_n.jpg','IMG_2506',NULL,0),(66,4,'2168458717792528173',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593013639_504883639_2058029_2507699_n.jpg','IMG_2507',NULL,0),(67,4,'2168458717792528174',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593043639_504883639_2058030_7904638_n.jpg','IMG_2508',NULL,0),(68,4,'2168458717792528175',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593068639_504883639_2058031_4339349_n.jpg','IMG_2512',NULL,0),(69,4,'2168458717792528176',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593088639_504883639_2058032_1469775_n.jpg','IMG_2513',NULL,0),(70,4,'2168458717792528177',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593098639_504883639_2058033_2772064_n.jpg','IMG_2514',NULL,0),(71,4,'2168458717792528178',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593118639_504883639_2058034_5885644_n.jpg','IMG_2517',NULL,0),(72,4,'2168458717792528185',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593203639_504883639_2058041_4028626_n.jpg','IMG_2519',NULL,0),(73,4,'2168458717792528186',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593228639_504883639_2058042_7374893_n.jpg','IMG_2520',NULL,0),(74,4,'2168458717792528187',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593248639_504883639_2058043_1663049_n.jpg','IMG_2521',NULL,0),(75,4,'2168458717792528188',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593283639_504883639_2058044_7589671_n.jpg','IMG_2522',NULL,0),(76,4,'2168458717792528189',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593308639_504883639_2058045_6481905_n.jpg','IMG_2523',NULL,0),(77,4,'2168458717792528190',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593348639_504883639_2058046_3802900_n.jpg','IMG_2524',NULL,0),(78,4,'2168458717792528191',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593373639_504883639_2058047_6742865_n.jpg','IMG_2525',NULL,0),(79,4,'2168458717792528192',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593403639_504883639_2058048_842376_n.jpg','IMG_2526',NULL,0),(80,4,'2168458717792528193',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593448639_504883639_2058049_2491096_n.jpg','IMG_2527',NULL,0),(81,4,'2168458717792528194',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593473639_504883639_2058050_7971002_n.jpg','IMG_2528',NULL,0),(82,4,'2168458717792528195',NULL,'2009-07-13 05:27:53','2009-07-13 05:27:53','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593493639_504883639_2058051_325000_n.jpg','IMG_2529',NULL,0),(83,4,'2168458717792528196',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593503639_504883639_2058052_2173547_n.jpg','IMG_2530',NULL,0),(84,4,'2168458717792528197',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593513639_504883639_2058053_7763217_n.jpg','IMG_2531',NULL,0),(85,4,'2168458717792528198',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593533639_504883639_2058054_6343782_n.jpg','IMG_2532',NULL,0),(86,4,'2168458717792528199',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593553639_504883639_2058055_7784081_n.jpg','IMG_2533',NULL,0),(87,4,'2168458717792528200',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593578639_504883639_2058056_4100229_n.jpg','IMG_2534',NULL,0),(88,4,'2168458717792528201',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593593639_504883639_2058057_7626754_n.jpg','IMG_2535',NULL,0),(89,4,'2168458717792528202',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593633639_504883639_2058058_3274869_n.jpg','IMG_2536',NULL,0),(90,4,'2168458717792528203',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593648639_504883639_2058059_1742022_n.jpg','IMG_2537',NULL,0),(91,4,'2168458717792528204',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593673639_504883639_2058060_3787101_n.jpg','IMG_2538',NULL,0),(92,4,'2168458717792528205',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593698639_504883639_2058061_1204543_n.jpg','IMG_2539',NULL,0),(93,4,'2168458717792528206',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593713639_504883639_2058062_55685_n.jpg','IMG_2540',NULL,0),(94,4,'2168458717792528207',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593738639_504883639_2058063_5345948_n.jpg','IMG_2541',NULL,0),(95,4,'2168458717792528208',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593763639_504883639_2058064_1992025_n.jpg','IMG_2542',NULL,0),(96,4,'2168458717792528209',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593778639_504883639_2058065_3897625_n.jpg','IMG_2543',NULL,0),(97,4,'2168458717792528210',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593798639_504883639_2058066_3730179_n.jpg','IMG_2544',NULL,0),(98,4,'2168458717792528211',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593813639_504883639_2058067_7545898_n.jpg','IMG_2545',NULL,0),(99,4,'2168458717792528212',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593833639_504883639_2058068_5149723_n.jpg','IMG_2546',NULL,0),(100,4,'2168458717792528213',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593868639_504883639_2058069_8027247_n.jpg','IMG_2547',NULL,0),(101,4,'2168458717792528214',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593883639_504883639_2058070_2332934_n.jpg','IMG_2548',NULL,0),(102,4,'2168458717792528223',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99593938639_504883639_2058079_4208064_n.jpg','IMG_2550',NULL,0),(103,4,'2168458717792528234',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99594008639_504883639_2058090_484483_n.jpg','IMG_2551',NULL,0),(104,4,'2168458717792528236',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99594028639_504883639_2058092_2178924_n.jpg','IMG_2552',NULL,0),(105,4,'2168458717792528237',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99594043639_504883639_2058093_4248035_n.jpg','IMG_2553',NULL,0),(106,4,'2168458717792528238',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99594058639_504883639_2058094_5222790_n.jpg','IMG_2554',NULL,0),(107,4,'2168458717792528240',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99594078639_504883639_2058096_3543468_n.jpg','IMG_2555',NULL,0),(108,4,'2168458717792528244',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99594108639_504883639_2058100_6322627_n.jpg','IMG_2556',NULL,0),(109,4,'2168458717792528246',NULL,'2009-07-13 05:27:54','2009-07-13 05:27:54','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99594133639_504883639_2058102_3222279_n.jpg','IMG_2557',NULL,0),(110,5,'2168458717792528116',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591608639_504883639_2057972_2080807_n.jpg','IMG_1384',NULL,0),(111,5,'2168458717792528117',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591628639_504883639_2057973_428709_n.jpg','IMG_1385',NULL,0),(112,5,'2168458717792528118',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591663639_504883639_2057974_4968127_n.jpg','IMG_1386',NULL,0),(113,5,'2168458717792528119',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591683639_504883639_2057975_1935711_n.jpg','IMG_1387',NULL,0),(114,5,'2168458717792528120',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591703639_504883639_2057976_369971_n.jpg','IMG_1388',NULL,0),(115,5,'2168458717792528121',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591718639_504883639_2057977_4284778_n.jpg','IMG_1389',NULL,0),(116,5,'2168458717792528122',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591733639_504883639_2057978_2012220_n.jpg','IMG_1390',NULL,0),(117,5,'2168458717792528123',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591748639_504883639_2057979_132319_n.jpg','IMG_1391',NULL,0),(118,5,'2168458717792528124',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591768639_504883639_2057980_2152174_n.jpg','IMG_1392',NULL,0),(119,5,'2168458717792528125',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591783639_504883639_2057981_312451_n.jpg','IMG_1393',NULL,0),(120,5,'2168458717792528126',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591798639_504883639_2057982_4276738_n.jpg','IMG_1394',NULL,0),(121,5,'2168458717792528127',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591818639_504883639_2057983_7319491_n.jpg','IMG_1397',NULL,0),(122,5,'2168458717792528128',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591838639_504883639_2057984_704289_n.jpg','IMG_1398',NULL,0),(123,5,'2168458717792528129',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591853639_504883639_2057985_1999349_n.jpg','IMG_1399',NULL,0),(124,5,'2168458717792528130',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591878639_504883639_2057986_5263490_n.jpg','IMG_2558',NULL,0),(125,5,'2168458717792528131',NULL,'2009-07-13 05:27:57','2009-07-13 05:27:57','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591888639_504883639_2057987_8359997_n.jpg','IMG_2559',NULL,0),(126,5,'2168458717792528132',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591898639_504883639_2057988_1944681_n.jpg','IMG_2560',NULL,0),(127,5,'2168458717792528133',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591908639_504883639_2057989_6115133_n.jpg','IMG_2561',NULL,0),(128,5,'2168458717792528134',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591923639_504883639_2057990_699746_n.jpg','IMG_2562',NULL,0),(129,5,'2168458717792528135',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591953639_504883639_2057991_7317081_n.jpg','IMG_2563',NULL,0),(130,5,'2168458717792528136',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591968639_504883639_2057992_4729476_n.jpg','IMG_2564',NULL,0),(131,5,'2168458717792528137',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592003639_504883639_2057993_5744940_n.jpg','IMG_2565',NULL,0),(132,5,'2168458717792528138',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592018639_504883639_2057994_7284089_n.jpg','IMG_2566',NULL,0),(133,5,'2168458717792528139',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592033639_504883639_2057995_6989191_n.jpg','IMG_2567',NULL,0),(134,5,'2168458717792528141',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592078639_504883639_2057997_3984943_n.jpg','IMG_2569',NULL,0),(135,5,'2168458717792528142',NULL,'2009-07-13 05:27:58','2009-07-13 05:27:58','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592098639_504883639_2057998_2591570_n.jpg','IMG_2570',NULL,0),(136,6,'2168458717792522056',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164203639_504883639_2051912_1248362_n.jpg','IMG_2424',NULL,0),(137,6,'2168458717792522057',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164288639_504883639_2051913_3257850_n.jpg','IMG_2428',NULL,0),(138,6,'2168458717792522058',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164403639_504883639_2051914_3841018_n.jpg','IMG_2429',NULL,0),(139,6,'2168458717792522059',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164473639_504883639_2051915_3781254_n.jpg','IMG_2431',NULL,0),(140,6,'2168458717792522063',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164558639_504883639_2051919_3998615_n.jpg','IMG_2433',NULL,0),(141,6,'2168458717792522064',NULL,'2009-07-13 05:28:01','2009-07-13 05:28:01','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164648639_504883639_2051920_201171_n.jpg','IMG_2434',NULL,0),(142,6,'2168458717792522065',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164688639_504883639_2051921_3358334_n.jpg','IMG_2435',NULL,0),(143,6,'2168458717792522066',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164718639_504883639_2051922_3493574_n.jpg','IMG_2437',NULL,0),(144,6,'2168458717792522067',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164743639_504883639_2051923_8285038_n.jpg','IMG_2438',NULL,0),(145,6,'2168458717792522068',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164763639_504883639_2051924_4382570_n.jpg','IMG_2440',NULL,0),(146,6,'2168458717792522069',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164803639_504883639_2051925_1251826_n.jpg','IMG_2441',NULL,0),(147,6,'2168458717792522070',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164833639_504883639_2051926_5397140_n.jpg','IMG_2442',NULL,0),(148,6,'2168458717792522071',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164858639_504883639_2051927_3510675_n.jpg','IMG_2443',NULL,0),(149,6,'2168458717792522072',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164873639_504883639_2051928_5121672_n.jpg','IMG_2444',NULL,0),(150,6,'2168458717792522073',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164898639_504883639_2051929_7443318_n.jpg','IMG_2446',NULL,0),(151,6,'2168458717792522074',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164918639_504883639_2051930_7339635_n.jpg','IMG_2447',NULL,0),(152,6,'2168458717792522075',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164933639_504883639_2051931_5026211_n.jpg','IMG_2448',NULL,0),(153,6,'2168458717792522076',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164943639_504883639_2051932_743539_n.jpg','IMG_2449',NULL,0),(154,6,'2168458717792522077',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99164978639_504883639_2051933_5569302_n.jpg','IMG_2450',NULL,0),(155,6,'2168458717792522078',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165003639_504883639_2051934_929213_n.jpg','IMG_2451',NULL,0),(156,6,'2168458717792522079',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165023639_504883639_2051935_6723071_n.jpg','IMG_2452',NULL,0),(157,6,'2168458717792522080',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165043639_504883639_2051936_2844067_n.jpg','IMG_2453',NULL,0),(158,6,'2168458717792522081',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165053639_504883639_2051937_7090993_n.jpg','IMG_2455',NULL,0),(159,6,'2168458717792522082',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165068639_504883639_2051938_1520742_n.jpg','IMG_2456',NULL,0),(160,6,'2168458717792522083',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165098639_504883639_2051939_3819384_n.jpg','IMG_2460',NULL,0),(161,6,'2168458717792522084',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165108639_504883639_2051940_4092180_n.jpg','IMG_2461',NULL,0),(162,6,'2168458717792522085',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165123639_504883639_2051941_1155837_n.jpg','IMG_2462',NULL,0),(163,6,'2168458717792522086',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165143639_504883639_2051942_6447677_n.jpg','IMG_2463',NULL,0),(164,6,'2168458717792522087',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99165153639_504883639_2051943_1668235_n.jpg','IMG_2465',NULL,0),(165,6,'2168458717792522088',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165173639_504883639_2051944_5530064_n.jpg','IMG_2466',NULL,0),(166,6,'2168458717792522089',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165188639_504883639_2051945_3973633_n.jpg','IMG_2469',NULL,0),(167,6,'2168458717792522090',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165203639_504883639_2051946_7401972_n.jpg','IMG_2470',NULL,0),(168,6,'2168458717792522091',NULL,'2009-07-13 05:28:02','2009-07-13 05:28:02','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99165213639_504883639_2051947_179013_n.jpg','IMG_2471',NULL,0),(169,7,'2168458717792517557',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047413_5733723.jpg','IMG_2357',NULL,0),(170,7,'2168458717792517558',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047414_5668906.jpg','IMG_2358',NULL,0),(171,7,'2168458717792517559',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047415_6779141.jpg','IMG_2359',NULL,0),(172,7,'2168458717792517560',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047416_8164763.jpg','IMG_2360',NULL,0),(173,7,'2168458717792517561',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047417_5386798.jpg','IMG_2362',NULL,0),(174,7,'2168458717792517562',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047418_253523.jpg','IMG_2364',NULL,0),(175,7,'2168458717792517563',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047419_1387360.jpg','IMG_2368',NULL,0),(176,7,'2168458717792517564',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047420_2452063.jpg','IMG_2371',NULL,0),(177,7,'2168458717792517565',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047421_2382550.jpg','IMG_2373',NULL,0),(178,7,'2168458717792517566',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047422_3427250.jpg','IMG_2374',NULL,0),(179,7,'2168458717792517567',NULL,'2009-07-13 05:28:05','2009-07-13 05:28:05','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047423_1946543.jpg','IMG_2377',NULL,0),(180,7,'2168458717792517568',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047424_7251396.jpg','IMG_2378',NULL,0),(181,7,'2168458717792517569',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047425_4673114.jpg','IMG_2379',NULL,0),(182,7,'2168458717792517570',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047426_252490.jpg','IMG_2380',NULL,0),(183,7,'2168458717792517571',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047427_1523202.jpg','IMG_2383',NULL,0),(184,7,'2168458717792517572',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047428_7916088.jpg','IMG_2385',NULL,0),(185,7,'2168458717792517573',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047429_6228164.jpg','IMG_2390',NULL,0),(186,7,'2168458717792517574',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047430_1182491.jpg','IMG_2395',NULL,0),(187,7,'2168458717792517575',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047431_6560708.jpg','IMG_2397',NULL,0),(188,7,'2168458717792517576',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047432_358966.jpg','IMG_2398',NULL,0),(189,7,'2168458717792517577',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047433_398329.jpg','IMG_2407',NULL,0),(190,7,'2168458717792517583',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047439_6494919.jpg','IMG_2410',NULL,0),(191,7,'2168458717792517584',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047440_6550229.jpg','IMG_2412',NULL,0),(192,7,'2168458717792517585',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047441_7251100.jpg','IMG_2413',NULL,0),(193,7,'2168458717792517586',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047442_896511.jpg','IMG_2419',NULL,0),(194,7,'2168458717792517587',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047443_2729318.jpg','IMG_2422',NULL,0),(195,7,'2168458717792517588',NULL,'2009-07-13 05:28:06','2009-07-13 05:28:06','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047444_206254.jpg','IMG_2423',NULL,0),(196,8,'2168458717792517440',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835533639_504883639_2047296_4956018_n.jpg','IMG_1339',NULL,0),(197,8,'2168458717792517441',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835558639_504883639_2047297_5051600_n.jpg','IMG_1340',NULL,0),(198,8,'2168458717792517442',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835568639_504883639_2047298_5035742_n.jpg','IMG_1341',NULL,0),(199,8,'2168458717792517443',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835593639_504883639_2047299_2451506_n.jpg','IMG_1348',NULL,0),(200,8,'2168458717792517444',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835623639_504883639_2047300_3028810_n.jpg','IMG_1349',NULL,0),(201,8,'2168458717792517445',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835638639_504883639_2047301_7360406_n.jpg','IMG_1350',NULL,0),(202,8,'2168458717792517446',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835668639_504883639_2047302_3800867_n.jpg','IMG_1351',NULL,0),(203,8,'2168458717792517447',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835683639_504883639_2047303_4237616_n.jpg','IMG_1352',NULL,0),(204,8,'2168458717792517448',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835708639_504883639_2047304_5967592_n.jpg','IMG_1353',NULL,0),(205,8,'2168458717792517449',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835723639_504883639_2047305_364968_n.jpg','IMG_1354',NULL,0),(206,8,'2168458717792517450',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835743639_504883639_2047306_1900241_n.jpg','IMG_1355',NULL,0),(207,8,'2168458717792517451',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835758639_504883639_2047307_3403718_n.jpg','IMG_1356',NULL,0),(208,8,'2168458717792517452',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835768639_504883639_2047308_7593544_n.jpg','IMG_1357',NULL,0),(209,8,'2168458717792517453',NULL,'2009-07-13 05:28:09','2009-07-13 05:28:09','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835793639_504883639_2047309_1546955_n.jpg','IMG_1358',NULL,0),(210,8,'2168458717792517454',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835833639_504883639_2047310_3011562_n.jpg','IMG_1359',NULL,0),(211,8,'2168458717792517455',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835853639_504883639_2047311_3755177_n.jpg','IMG_1360',NULL,0),(212,8,'2168458717792517456',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835868639_504883639_2047312_4103302_n.jpg','IMG_1361',NULL,0),(213,8,'2168458717792517458',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835893639_504883639_2047314_3123234_n.jpg','IMG_1362',NULL,0),(214,8,'2168458717792517459',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835908639_504883639_2047315_5040106_n.jpg','IMG_1363',NULL,0),(215,8,'2168458717792517460',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835933639_504883639_2047316_8289703_n.jpg','IMG_1364',NULL,0),(216,8,'2168458717792517461',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835948639_504883639_2047317_5320609_n.jpg','IMG_1365',NULL,0),(217,8,'2168458717792517462',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98835973639_504883639_2047318_7910042_n.jpg','IMG_1366',NULL,0),(218,8,'2168458717792517463',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836013639_504883639_2047319_6092271_n.jpg','IMG_1367',NULL,0),(219,8,'2168458717792517464',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836028639_504883639_2047320_6716401_n.jpg','IMG_1368',NULL,0),(220,8,'2168458717792517465',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836043639_504883639_2047321_1198583_n.jpg','IMG_1369',NULL,0),(221,8,'2168458717792517466',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836058639_504883639_2047322_2934549_n.jpg','IMG_1370',NULL,0),(222,8,'2168458717792517467',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836078639_504883639_2047323_4308616_n.jpg','IMG_1371',NULL,0),(223,8,'2168458717792517468',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836098639_504883639_2047324_7237161_n.jpg','IMG_1373',NULL,0),(224,8,'2168458717792517469',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836118639_504883639_2047325_7286510_n.jpg','IMG_1374',NULL,0),(225,8,'2168458717792517470',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836128639_504883639_2047326_4810640_n.jpg','IMG_1376',NULL,0),(226,8,'2168458717792517471',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836143639_504883639_2047327_1288420_n.jpg','IMG_1377',NULL,0),(227,8,'2168458717792517472',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836158639_504883639_2047328_3081597_n.jpg','IMG_1378',NULL,0),(228,8,'2168458717792517473',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98836178639_504883639_2047329_5939234_n.jpg','IMG_1379',NULL,0),(229,8,'2168458717792517474',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836193639_504883639_2047330_1315562_n.jpg','IMG_1380',NULL,0),(230,8,'2168458717792517475',NULL,'2009-07-13 05:28:10','2009-07-13 05:28:10','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98836223639_504883639_2047331_7270911_n.jpg','IMG_1381',NULL,0),(231,9,'2168458717792515960',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714603639_504883639_2045816_1323138_n.jpg','IMG_2303',NULL,0),(232,9,'2168458717792515961',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714623639_504883639_2045817_1835286_n.jpg','IMG_2304',NULL,0),(233,9,'2168458717792515962',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714653639_504883639_2045818_2842033_n.jpg','IMG_2305',NULL,0),(234,9,'2168458717792515963',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714678639_504883639_2045819_1518590_n.jpg','IMG_2306',NULL,0),(235,9,'2168458717792515964',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714768639_504883639_2045820_6620725_n.jpg','IMG_2308',NULL,0),(236,9,'2168458717792515965',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714793639_504883639_2045821_31584_n.jpg','IMG_2309',NULL,0),(237,9,'2168458717792515967',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714818639_504883639_2045823_3906494_n.jpg','IMG_2310',NULL,0),(238,9,'2168458717792515968',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714838639_504883639_2045824_4176684_n.jpg','IMG_2312','--- \n- Trevor Edmond\n',0),(239,9,'2168458717792515969',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714868639_504883639_2045825_941510_n.jpg','IMG_2314',NULL,0),(240,9,'2168458717792515970',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714878639_504883639_2045826_6468817_n.jpg','IMG_2315',NULL,0),(241,9,'2168458717792515971',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714908639_504883639_2045827_6208952_n.jpg','IMG_2317',NULL,0),(242,9,'2168458717792515972',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714943639_504883639_2045828_5683337_n.jpg','IMG_2318',NULL,0),(243,9,'2168458717792515973',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98714983639_504883639_2045829_6632031_n.jpg','IMG_2322',NULL,0),(244,9,'2168458717792515974',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715013639_504883639_2045830_1974891_n.jpg','IMG_2323',NULL,0),(245,9,'2168458717792515975',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715033639_504883639_2045831_53534_n.jpg','IMG_2324',NULL,0),(246,9,'2168458717792515976',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715098639_504883639_2045832_105601_n.jpg','IMG_2325',NULL,0),(247,9,'2168458717792515977',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715118639_504883639_2045833_3616052_n.jpg','IMG_2326',NULL,0),(248,9,'2168458717792515978',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715168639_504883639_2045834_7309267_n.jpg','IMG_2327',NULL,0),(249,9,'2168458717792515980',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715198639_504883639_2045836_1477428_n.jpg','IMG_2328',NULL,0),(250,9,'2168458717792515981',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715218639_504883639_2045837_4395278_n.jpg','IMG_2329',NULL,0),(251,9,'2168458717792515982',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715248639_504883639_2045838_2750964_n.jpg','IMG_2330',NULL,0),(252,9,'2168458717792515983',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715288639_504883639_2045839_2770122_n.jpg','IMG_2331',NULL,0),(253,9,'2168458717792515984',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715308639_504883639_2045840_5007441_n.jpg','IMG_2332',NULL,0),(254,9,'2168458717792515985',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715328639_504883639_2045841_515771_n.jpg','IMG_2334',NULL,0),(255,9,'2168458717792515986',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715363639_504883639_2045842_4296599_n.jpg','IMG_2335',NULL,0),(256,9,'2168458717792515987',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715393639_504883639_2045843_1351343_n.jpg','IMG_2336',NULL,0),(257,9,'2168458717792515988',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715413639_504883639_2045844_1925682_n.jpg','IMG_2337',NULL,0),(258,9,'2168458717792515989',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715443639_504883639_2045845_3280412_n.jpg','IMG_2339',NULL,0),(259,9,'2168458717792515990',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715483639_504883639_2045846_2661896_n.jpg','IMG_2340',NULL,0),(260,9,'2168458717792515991',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715528639_504883639_2045847_131293_n.jpg','IMG_2345',NULL,0),(261,9,'2168458717792515992',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715578639_504883639_2045848_2671379_n.jpg','IMG_2346',NULL,0),(262,9,'2168458717792515993',NULL,'2009-07-13 05:28:14','2009-07-13 05:28:14','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715593639_504883639_2045849_4000641_n.jpg','IMG_2347',NULL,0),(263,9,'2168458717792515994',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715628639_504883639_2045850_1837944_n.jpg','IMG_2349',NULL,0),(264,9,'2168458717792515995',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715753639_504883639_2045851_6838376_n.jpg','IMG_2350',NULL,0),(265,9,'2168458717792515996',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715798639_504883639_2045852_5963813_n.jpg','IMG_2351',NULL,0),(266,9,'2168458717792515997',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715848639_504883639_2045853_1134392_n.jpg','IMG_2352',NULL,0),(267,9,'2168458717792515998',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715898639_504883639_2045854_1459107_n.jpg','IMG_2354',NULL,0),(268,9,'2168458717792515999',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715938639_504883639_2045855_1481297_n.jpg','IMG_2355',NULL,0),(269,9,'2168458717792516000',NULL,'2009-07-13 05:28:15','2009-07-13 05:28:15','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715968639_504883639_2045856_7521095_n.jpg','IMG_2356',NULL,0),(270,10,'2168458717792515937',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045793_3864617.jpg','IMG_1322',NULL,0),(271,10,'2168458717792515940',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045796_521796.jpg','IMG_1323',NULL,0),(272,10,'2168458717792515941',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045797_3936659.jpg','IMG_1324',NULL,0),(273,10,'2168458717792515942',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045798_7722916.jpg','IMG_1328',NULL,0),(274,10,'2168458717792515943',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045799_2562791.jpg','IMG_1329',NULL,0),(275,10,'2168458717792515944',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045800_5541453.jpg','IMG_1330',NULL,0),(276,10,'2168458717792515945',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045801_3866798.jpg','IMG_1331',NULL,0),(277,10,'2168458717792515946',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045802_591105.jpg','IMG_1332',NULL,0),(278,10,'2168458717792515947',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045803_1498812.jpg','IMG_1333',NULL,0),(279,10,'2168458717792515948',NULL,'2009-07-13 05:28:17','2009-07-13 05:28:17','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045804_5072974.jpg','IMG_1334',NULL,0),(280,10,'2168458717792515949',NULL,'2009-07-13 05:28:18','2009-07-13 05:28:18','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045805_7154800.jpg','IMG_1335',NULL,0),(281,10,'2168458717792515950',NULL,'2009-07-13 05:28:18','2009-07-13 05:28:18','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045806_5515763.jpg','IMG_1336',NULL,0),(282,10,'2168458717792515951',NULL,'2009-07-13 05:28:18','2009-07-13 05:28:18','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045807_7768329.jpg','IMG_1337',NULL,0),(283,10,'2168458717792515952',NULL,'2009-07-13 05:28:18','2009-07-13 05:28:18','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2045808_2944485.jpg','IMG_1338',NULL,0),(284,11,'2168458717792515922',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712543639_504883639_2045778_678206_n.jpg','IMG_1282',NULL,0),(285,11,'2168458717792515923',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712573639_504883639_2045779_7191758_n.jpg','IMG_1283',NULL,0),(286,11,'2168458717792515924',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712603639_504883639_2045780_6002293_n.jpg','IMG_1284',NULL,0),(287,11,'2168458717792515925',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712628639_504883639_2045781_883093_n.jpg','IMG_1305',NULL,0),(288,11,'2168458717792515926',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712653639_504883639_2045782_1619811_n.jpg','IMG_1308',NULL,0),(289,11,'2168458717792515927',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712703639_504883639_2045783_7220252_n.jpg','IMG_1309',NULL,0),(290,11,'2168458717792515928',NULL,'2009-07-13 05:28:20','2009-07-13 05:28:20','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712748639_504883639_2045784_6485956_n.jpg','IMG_1310',NULL,0),(291,11,'2168458717792515929',NULL,'2009-07-13 05:28:21','2009-07-13 05:28:21','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712773639_504883639_2045785_5331716_n.jpg','IMG_1312',NULL,0),(292,11,'2168458717792515930',NULL,'2009-07-13 05:28:21','2009-07-13 05:28:21','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712798639_504883639_2045786_4966778_n.jpg','IMG_1313',NULL,0),(293,11,'2168458717792515931',NULL,'2009-07-13 05:28:21','2009-07-13 05:28:21','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98712828639_504883639_2045787_3981447_n.jpg','IMG_1314',NULL,0),(294,11,'2168458717792515932',NULL,'2009-07-13 05:28:21','2009-07-13 05:28:21','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712838639_504883639_2045788_6144862_n.jpg','IMG_1315',NULL,0),(295,11,'2168458717792515933',NULL,'2009-07-13 05:28:21','2009-07-13 05:28:21','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712858639_504883639_2045789_260505_n.jpg','IMG_1317',NULL,0),(296,12,'2168458717792493808',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659418639_504883639_2023664_5445528_n.jpg','IMG_1243','--- \n- Robin Schauer\n',0),(297,12,'2168458717792493809',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659598639_504883639_2023665_3715044_n.jpg','IMG_1244','--- \n- Robin Schauer\n',0),(298,12,'2168458717792493810',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659613639_504883639_2023666_3645362_n.jpg','IMG_1246','--- \n- Robin Schauer\n',0),(299,12,'2168458717792493811',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659793639_504883639_2023667_541350_n.jpg','IMG_1247','--- \n- Ryan Edmond\n',0),(300,12,'2168458717792493812',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97659818639_504883639_2023668_8031237_n.jpg','IMG_1248','--- \n- Trevor Edmond\n',0),(301,12,'2168458717792493813',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97659843639_504883639_2023669_4131442_n.jpg','IMG_1249','--- \n- Ryan Edmond\n',0),(302,12,'2168458717792493817',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659883639_504883639_2023673_2150472_n.jpg','IMG_1250',NULL,0),(303,12,'2168458717792493818',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97659958639_504883639_2023674_3280845_n.jpg','IMG_1251',NULL,0),(304,12,'2168458717792493819',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97660043639_504883639_2023675_4254880_n.jpg','IMG_1253','--- \n- Robin Schauer\n',0),(305,12,'2168458717792493820',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97660058639_504883639_2023676_6352836_n.jpg','IMG_1254',NULL,0),(306,12,'2168458717792493842',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97660318639_504883639_2023698_2596487_n.jpg','IMG_1255',NULL,0),(307,12,'2168458717792493844',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97660663639_504883639_2023700_515213_n.jpg','IMG_1256',NULL,0),(308,12,'2168458717792493845',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97660763639_504883639_2023701_815520_n.jpg','IMG_1257','--- \n- Ryan Edmond\n- Trevor Edmond\n',0),(309,12,'2168458717792493847',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97660853639_504883639_2023703_16584_n.jpg','IMG_1259',NULL,0),(310,12,'2168458717792493848',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97660898639_504883639_2023704_5625510_n.jpg','IMG_1261','--- \n- Robin Schauer\n',0),(311,12,'2168458717792493849',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97660913639_504883639_2023705_2576412_n.jpg','IMG_1263','--- \n- Robin Schauer\n',0),(312,12,'2168458717792493851',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97660963639_504883639_2023707_7122376_n.jpg','IMG_1264','--- \n- Robin Schauer\n',0),(313,12,'2168458717792493852',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97660983639_504883639_2023708_3349149_n.jpg','IMG_1265',NULL,0),(314,12,'2168458717792493853',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97661013639_504883639_2023709_4931379_n.jpg','IMG_1266',NULL,0),(315,12,'2168458717792493854',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97661078639_504883639_2023710_6677135_n.jpg','IMG_1267',NULL,0),(316,12,'2168458717792493855',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97661128639_504883639_2023711_4719079_n.jpg','IMG_1268','--- \n- Trevor Edmond\n',0),(317,12,'2168458717792493856',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97661168639_504883639_2023712_7558962_n.jpg','IMG_1269',NULL,0),(318,12,'2168458717792493857',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_97661193639_504883639_2023713_1280407_n.jpg','IMG_1271',NULL,0),(319,12,'2168458717792493858',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97661258639_504883639_2023714_4632145_n.jpg','IMG_1272',NULL,0),(320,12,'2168458717792493859',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97661323639_504883639_2023715_3158120_n.jpg','IMG_1273',NULL,0),(321,12,'2168458717792493860',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97661843639_504883639_2023716_8020872_n.jpg','IMG_1274',NULL,0),(322,12,'2168458717792493861',NULL,'2009-07-13 05:28:24','2009-07-13 05:28:24','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023717_1569920.jpg','IMG_1275',NULL,0),(323,12,'2168458717792493862',NULL,'2009-07-13 05:28:25','2009-07-13 05:28:25','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023718_6189194.jpg','IMG_1276',NULL,0),(324,12,'2168458717792493863',NULL,'2009-07-13 05:28:25','2009-07-13 05:28:25','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023719_4937796.jpg','IMG_1277','--- \n- Robin Schauer\n',0),(325,12,'2168458717792493873',NULL,'2009-07-13 05:28:25','2009-07-13 05:28:25','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023729_4035951.jpg','IMG_1278','--- \n- Robin Schauer\n',0),(326,12,'2168458717792493874',NULL,'2009-07-13 05:28:25','2009-07-13 05:28:25','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023730_3115019.jpg','IMG_1279',NULL,0),(327,12,'2168458717792493875',NULL,'2009-07-13 05:28:25','2009-07-13 05:28:25','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023731_4398497.jpg','IMG_1280',NULL,0),(328,13,'2168458717792430501',NULL,'2009-07-13 05:28:27','2009-07-13 05:28:27','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93624863639_504883639_1960357_4561644_n.jpg','Picture 1',NULL,0),(329,14,'2168458717792423010',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156583639_504883639_1952866_2884683_n.jpg','IMG_8196','--- \n- Andrew\n- Jack\n- Natalie\n',0),(330,14,'2168458717792423011',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156608639_504883639_1952867_518104_n.jpg','IMG_8368','--- \n- Jack\n',0),(331,14,'2168458717792423013',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156648639_504883639_1952869_6072646_n.jpg','Picture 007','--- \n- Jack\n',0),(332,14,'2168458717792423014',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156698639_504883639_1952870_5700789_n.jpg','IMG_8961','--- \n- Jack\n',0),(333,14,'2168458717792423015',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156768639_504883639_1952871_3822233_n.jpg','IMG_0049','--- \n- Jack\n',0),(334,14,'2168458717792423016',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156798639_504883639_1952872_5292928_n.jpg','IMG_0063','--- \n- Jack\n',0),(335,14,'2168458717792423017',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156868639_504883639_1952873_5352840_n.jpg','IMG_0209','--- \n- Natalie\n- Jack\n',0),(336,14,'2168458717792423018',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156938639_504883639_1952874_1111456_n.jpg','IMG_2047','--- \n- Andrew\n- Jack\n',0),(337,14,'2168458717792423019',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156958639_504883639_1952875_6878976_n.jpg','IMG_2064','--- \n- Jack\n- Natalie\n- Andrew\n',0),(338,14,'2168458717792423020',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156978639_504883639_1952876_4440969_n.jpg','IMG_2788','--- \n- Jack\n',0),(339,14,'2168458717792423021',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157033639_504883639_1952877_5191364_n.jpg','IMG_0921','--- \n- Mima\n- Jack\n- Andrew\n',0),(340,14,'2168458717792423022',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157053639_504883639_1952878_6986749_n.jpg','andy_s_son_5_may07','--- \n- Jack\n- Andrew\n',0),(341,14,'2168458717792423023',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157103639_504883639_1952879_2647332_n.jpg','877867826_90f551a01b','--- \n- Deidra\n- Andrew\n- Jack\n',0),(342,14,'2168458717792423024',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157143639_504883639_1952880_1954331_n.jpg','HPIM0309.JPG','--- \n- Andrew\n- Jack\n',0),(343,14,'2168458717792423025',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157198639_504883639_1952881_3637490_n.jpg','HPIM0595.JPG','--- \n- Andrew\n- Jack\n',0),(344,14,'2168458717792423026',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157223639_504883639_1952882_7974713_n.jpg','20080511_1638','--- \n- Natalie\n- Jack\n- Mima\n- Andrew\n- Papa Keenan\n- Trevor Edmond\n',0),(345,14,'2168458717792423028',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157303639_504883639_1952884_7460880_n.jpg','26790002','--- \n- Andrew\n- Jack\n- Natalie\n',0),(346,14,'2168458717792423029',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157338639_504883639_1952885_173192_n.jpg','26790004','--- \n- Mima\n- Jack\n',0),(347,14,'2168458717792423030',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157368639_504883639_1952886_413516_n.jpg','26790005','--- \n- Ryan\n- Papa Keenan\n- Andrew\n- Mima\n- Natalie\n- Jack\n',0),(348,14,'2168458717792423031',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157398639_504883639_1952887_2021431_n.jpg','IMG_1067.JPG','--- \n- Jack\n',0),(349,14,'2168458717792423032',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157433639_504883639_1952888_4487118_n.jpg','IMG_1076.JPG','--- \n- Andrew\n- Jack\n',0),(350,14,'2168458717792423033',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157508639_504883639_1952889_596412_n.jpg','IMG_1139.JPG','--- \n- Jack\n',0),(351,14,'2168458717792423034',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157563639_504883639_1952890_2450897_n.jpg','IMG_1155.JPG','--- \n- Jack\n- Andrew\n',0),(352,14,'2168458717792423035',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157623639_504883639_1952891_7487760_n.jpg','164_164',NULL,0),(353,14,'2168458717792423039',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157693639_504883639_1952895_6969302_n.jpg','IMG_1001',NULL,0),(354,14,'2168458717792423047',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157763639_504883639_1952903_2202647_n.jpg','IMG_1431',NULL,0),(355,14,'2168458717792423057',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157858639_504883639_1952913_6129605_n.jpg','115_115',NULL,0),(356,14,'2168458717792423064',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157923639_504883639_1952920_6474146_n.jpg','IMG_1438',NULL,0),(357,14,'2168458717792423065',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157958639_504883639_1952921_7785529_n.jpg','IMG_1422',NULL,0),(358,14,'2168458717792423066',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93157983639_504883639_1952922_324390_n.jpg','IMG_2755',NULL,0),(359,14,'2168458717792423067',NULL,'2009-07-13 05:28:31','2009-07-13 05:28:31','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93158003639_504883639_1952923_7274000_n.jpg','877867758_7a8a5fde53',NULL,0),(360,15,'2168458717792422967',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952823_904894.jpg','IMG_1212',NULL,0),(361,15,'2168458717792422968',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952824_3703593.jpg','IMG_1213',NULL,0),(362,15,'2168458717792422969',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952825_4167047.jpg','IMG_1214',NULL,0),(363,15,'2168458717792422970',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952826_3293877.jpg','IMG_1215',NULL,0),(364,15,'2168458717792422971',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952827_5345957.jpg','IMG_1216',NULL,0),(365,15,'2168458717792422972',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952828_4205694.jpg','IMG_1217',NULL,0),(366,15,'2168458717792422973',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952829_5907658.jpg','IMG_1218',NULL,0),(367,15,'2168458717792422974',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952830_6182346.jpg','IMG_1219',NULL,0),(368,15,'2168458717792422975',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952831_6877056.jpg','IMG_1228',NULL,0),(369,15,'2168458717792422976',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952832_7726888.jpg','IMG_1230',NULL,0),(370,15,'2168458717792422977',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952833_5752470.jpg','IMG_1231',NULL,0),(371,15,'2168458717792422978',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952834_7460335.jpg','IMG_1232',NULL,0),(372,15,'2168458717792422979',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952835_2891770.jpg','IMG_1235',NULL,0),(373,15,'2168458717792422980',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952836_5645586.jpg','IMG_1237',NULL,0),(374,15,'2168458717792422981',NULL,'2009-07-13 05:28:34','2009-07-13 05:28:34','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/n504883639_1952837_1750455.jpg','IMG_1239',NULL,0),(375,16,'2168458717792387143',NULL,'2009-07-13 05:28:37','2009-07-13 05:28:37','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/n504883639_1916999_6135972.jpg','002_2',NULL,0),(376,16,'2168458717792387144',NULL,'2009-07-13 05:28:37','2009-07-13 05:28:37','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/n504883639_1917000_6432666.jpg','003_3',NULL,0),(377,16,'2168458717792387145',NULL,'2009-07-13 05:28:37','2009-07-13 05:28:37','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/n504883639_1917001_8036523.jpg','004_4',NULL,0),(378,17,'2168458717792313288',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680298639_504883639_1843144_6191347_n.jpg','IMG_1198',NULL,0),(379,17,'2168458717792313289',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680323639_504883639_1843145_6509577_n.jpg','IMG_1199',NULL,0),(380,17,'2168458717792313290',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680338639_504883639_1843146_7216025_n.jpg','IMG_1200',NULL,0),(381,17,'2168458717792313291',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680353639_504883639_1843147_6883968_n.jpg','IMG_1205',NULL,0),(382,17,'2168458717792313292',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85680368639_504883639_1843148_6613376_n.jpg','IMG_1206',NULL,0),(383,17,'2168458717792313293',NULL,'2009-07-13 05:28:39','2009-07-13 05:28:39','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85680383639_504883639_1843149_8371578_n.jpg','IMG_1207',NULL,0),(384,18,'2168458717792313276',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85679738639_504883639_1843132_8117613_n.jpg','IMG_1185',NULL,0),(385,18,'2168458717792313277',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85679753639_504883639_1843133_7634168_n.jpg','IMG_1186',NULL,0),(386,18,'2168458717792313278',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679763639_504883639_1843134_4182462_n.jpg','IMG_1187',NULL,0),(387,18,'2168458717792313279',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679773639_504883639_1843135_6012887_n.jpg','IMG_1188',NULL,0),(388,18,'2168458717792313280',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679783639_504883639_1843136_4232009_n.jpg','IMG_1189',NULL,0),(389,18,'2168458717792313281',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679793639_504883639_1843137_1545602_n.jpg','IMG_1190',NULL,0),(390,18,'2168458717792313282',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85679808639_504883639_1843138_3232197_n.jpg','IMG_1191',NULL,0),(391,18,'2168458717792313283',NULL,'2009-07-13 05:28:42','2009-07-13 05:28:42','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85679818639_504883639_1843139_6153648_n.jpg','IMG_1192',NULL,0),(392,19,'2168458717792280708',NULL,'2009-07-13 05:28:45','2009-07-13 05:28:45','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_83405823639_504883639_1810564_6426598_n.jpg','IMG_1177',NULL,0),(393,19,'2168458717792280709',NULL,'2009-07-13 05:28:45','2009-07-13 05:28:45','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_83405843639_504883639_1810565_5659759_n.jpg','IMG_1180',NULL,0),(394,20,'2168458717792245666',NULL,'2009-07-13 05:28:47','2009-07-13 05:28:47','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81114303639_504883639_1775522_3233172_n.jpg','IMG_1125','--- \n- Trevor Edmond\n',0),(395,21,'2168458717792245571',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109178639_504883639_1775427_3923215_n.jpg','IMG_1123',NULL,0),(396,21,'2168458717792245572',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109188639_504883639_1775428_5807054_n.jpg','IMG_1126',NULL,0),(397,21,'2168458717792245573',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109213639_504883639_1775429_5033380_n.jpg','IMG_1134','--- \n- Robin Schauer\n',0),(398,21,'2168458717792245574',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109223639_504883639_1775430_4493859_n.jpg','IMG_1136','--- \n- Trevor Edmond\n',0),(399,21,'2168458717792245575',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109238639_504883639_1775431_778123_n.jpg','IMG_1138','--- \n- Robin Schauer\n',0),(400,21,'2168458717792245576',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109263639_504883639_1775432_4427000_n.jpg','IMG_1139','--- \n- Trevor Edmond\n',0),(401,21,'2168458717792245577',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109273639_504883639_1775433_7348925_n.jpg','IMG_1140','--- \n- Robin Schauer\n',0),(402,21,'2168458717792245578',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109293639_504883639_1775434_5007096_n.jpg','IMG_1141','--- \n- Robin Schauer\n',0),(403,21,'2168458717792245579',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109323639_504883639_1775435_7529483_n.jpg','IMG_1142',NULL,0),(404,21,'2168458717792245580',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109333639_504883639_1775436_6600687_n.jpg','IMG_1143',NULL,0),(405,21,'2168458717792245581',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109343639_504883639_1775437_6195850_n.jpg','IMG_1144',NULL,0),(406,21,'2168458717792245582',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109378639_504883639_1775438_990916_n.jpg','IMG_1148','--- \n- Robin Schauer\n- Andrew Edmond\n',0),(407,21,'2168458717792245583',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109393639_504883639_1775439_4055165_n.jpg','IMG_1152',NULL,0),(408,21,'2168458717792245584',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109403639_504883639_1775440_222996_n.jpg','IMG_1153','--- \n- Trevor Edmond\n',0),(409,21,'2168458717792245585',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109413639_504883639_1775441_7234377_n.jpg','IMG_1154','--- \n- Robin Schauer\n- Andrew Edmond\n',0),(410,21,'2168458717792245586',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109428639_504883639_1775442_5006486_n.jpg','IMG_1155','--- \n- Robin Schauer\n- Andrew Edmond\n',0),(411,21,'2168458717792245587',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109443639_504883639_1775443_5908942_n.jpg','IMG_1157',NULL,0),(412,21,'2168458717792245588',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109458639_504883639_1775444_5649210_n.jpg','IMG_1158',NULL,0),(413,21,'2168458717792245590',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109478639_504883639_1775446_390134_n.jpg','IMG_1159',NULL,0),(414,21,'2168458717792245591',NULL,'2009-07-13 05:28:50','2009-07-13 05:28:50','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109493639_504883639_1775447_3165801_n.jpg','IMG_1160',NULL,0),(415,22,'2168458717792205620',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327158639_504883639_1735476_7368232_n.jpg','Azzura_Photography_Finals_1_resize',NULL,0),(416,22,'2168458717792205621',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327188639_504883639_1735477_6176246_n.jpg','Azzura_Photography_Finals_2_resize',NULL,0),(417,22,'2168458717792205622',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327208639_504883639_1735478_584478_n.jpg','Azzura_Photography_Finals_3_resize',NULL,0),(418,22,'2168458717792205623',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327223639_504883639_1735479_759366_n.jpg','Azzura_Photography_Finals_6_resize',NULL,0),(419,22,'2168458717792205624',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327233639_504883639_1735480_8288125_n.jpg','Azzura_Photography_Finals_7_resize',NULL,0),(420,22,'2168458717792205625',NULL,'2009-07-13 05:28:53','2009-07-13 05:28:53','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327253639_504883639_1735481_3049101_n.jpg','Azzura_Photography_Finals_4_resize',NULL,0),(421,23,'2168458717792161830',NULL,'2009-07-13 05:28:55','2009-07-13 05:28:55','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1691686_6511737.jpg','dilbert_cropped',NULL,0),(422,24,'2168458717792123626',NULL,'2009-07-13 05:28:58','2009-07-13 05:28:58','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1653482_822251.jpg','Robin, thinking it\'s a good idea to sing! :)',NULL,0),(423,25,'2168458717792090624',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620480_2350726.jpg','IMG_1066',NULL,0),(424,25,'2168458717792090625',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620481_5681139.jpg','IMG_1070',NULL,0),(425,25,'2168458717792090626',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620482_4830270.jpg','IMG_1075',NULL,0),(426,25,'2168458717792090627',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620483_7080581.jpg','IMG_1077',NULL,0),(427,25,'2168458717792090628',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620484_8070016.jpg','IMG_1078',NULL,0),(428,25,'2168458717792090629',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620485_5037515.jpg','IMG_1079',NULL,0),(429,25,'2168458717792090630',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620486_5239071.jpg','IMG_1089',NULL,0),(430,25,'2168458717792090631',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620487_4625054.jpg','IMG_1093',NULL,0),(431,25,'2168458717792090632',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620488_1520445.jpg','IMG_1094',NULL,0),(432,25,'2168458717792090633',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620489_986424.jpg','IMG_1095',NULL,0),(433,25,'2168458717792090634',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620490_4511604.jpg','IMG_1097',NULL,0),(434,25,'2168458717792090635',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620491_3864168.jpg','IMG_1098',NULL,0),(435,25,'2168458717792090636',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620492_4371428.jpg','IMG_1100',NULL,0),(436,25,'2168458717792090637',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620493_6128901.jpg','IMG_1101',NULL,0),(437,25,'2168458717792090638',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620494_119626.jpg','IMG_1102',NULL,0),(438,25,'2168458717792090639',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620495_1084564.jpg','IMG_1103',NULL,0),(439,25,'2168458717792090640',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620496_2311460.jpg','IMG_1108',NULL,0),(440,25,'2168458717792090641',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620497_1235345.jpg','IMG_1109',NULL,0),(441,25,'2168458717792090642',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620498_263382.jpg','IMG_1112',NULL,0),(442,25,'2168458717792090643',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620499_269274.jpg','IMG_1114',NULL,0),(443,25,'2168458717792090644',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620500_5481837.jpg','IMG_1115',NULL,0),(444,25,'2168458717792090645',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620501_1779459.jpg','IMG_1116',NULL,0),(445,25,'2168458717792090646',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620502_6120147.jpg','IMG_1117',NULL,0),(446,25,'2168458717792090647',NULL,'2009-07-13 05:29:01','2009-07-13 05:29:01','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620503_3206901.jpg','IMG_1119',NULL,0),(447,26,'2168458717792032931',NULL,'2009-07-13 05:29:04','2009-07-13 05:29:04','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562787_215659.jpg','IMG_1042',NULL,0),(448,26,'2168458717792032932',NULL,'2009-07-13 05:29:04','2009-07-13 05:29:04','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562788_6185829.jpg','IMG_1050',NULL,0),(449,26,'2168458717792032933',NULL,'2009-07-13 05:29:04','2009-07-13 05:29:04','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562789_7483857.jpg','IMG_1054',NULL,0),(450,26,'2168458717792032934',NULL,'2009-07-13 05:29:04','2009-07-13 05:29:04','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562790_6410219.jpg','IMG_1056',NULL,0),(451,26,'2168458717792032935',NULL,'2009-07-13 05:29:04','2009-07-13 05:29:04','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562791_654014.jpg','IMG_1057',NULL,0),(452,27,'2168458717791299464',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829320_3023.jpg','',NULL,0),(453,27,'2168458717791299465',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829321_5211.jpg','',NULL,0),(454,27,'2168458717791299466',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829322_7499.jpg','',NULL,0),(455,27,'2168458717791299467',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829323_246.jpg','',NULL,0),(456,27,'2168458717791299468',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829324_2595.jpg','',NULL,0),(457,27,'2168458717791299470',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829326_6921.jpg','',NULL,0),(458,27,'2168458717791299471',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829327_9625.jpg','',NULL,0),(459,27,'2168458717791299472',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829328_2534.jpg','',NULL,0),(460,27,'2168458717791299473',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829329_4984.jpg','',NULL,0),(461,27,'2168458717791299474',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829330_7642.jpg','','--- \n- Tracy Ballard\n',0),(462,27,'2168458717791299475',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829331_9704.jpg','',NULL,0),(463,27,'2168458717791299476',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829332_2094.jpg','',NULL,0),(464,27,'2168458717791299477',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829333_4889.jpg','','--- \n- Tracy Ballard\n',0),(465,27,'2168458717791299478',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829334_6632.jpg','Sunrise','--- \n- Tracy Ballard\n- Andrew Edmond\n',0),(466,27,'2168458717791299479',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829335_9873.jpg','Yes I can!',NULL,0),(467,27,'2168458717791299480',NULL,'2009-07-13 05:29:07','2009-07-13 05:29:07','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829336_2277.jpg','Told ya so',NULL,0),(468,27,'2168458717791299481',NULL,'2009-07-13 05:29:08','2009-07-13 05:29:08','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829337_4647.jpg','',NULL,0),(469,27,'2168458717791299482',NULL,'2009-07-13 05:29:08','2009-07-13 05:29:08','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829338_7011.jpg','',NULL,0),(470,28,'2168458717791956114',NULL,'2009-07-13 05:29:10','2009-07-13 05:29:10','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2620/77/120/504883639/n504883639_1485970_7481320.jpg','IMG_0437',NULL,0),(471,28,'2168458717791956116',NULL,'2009-07-13 05:29:10','2009-07-13 05:29:10','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2620/77/120/504883639/n504883639_1485972_2541528.jpg','IMG_0438',NULL,0),(472,28,'2168458717791956115',NULL,'2009-07-13 05:29:10','2009-07-13 05:29:10','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2404/77/120/504883639/n504883639_1485971_5110241.jpg','IMG_0441',NULL,0),(473,28,'2168458717791956112',NULL,'2009-07-13 05:29:10','2009-07-13 05:29:10','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2620/77/120/504883639/n504883639_1485968_5413500.jpg','IMG_0443','--- \n- Trevor Edmond\n',0),(474,29,'2168458717791943969',NULL,'2009-07-13 05:29:12','2009-07-13 05:29:12','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1473825_4454136.jpg','IMG_0425',NULL,0),(475,29,'2168458717791943970',NULL,'2009-07-13 05:29:12','2009-07-13 05:29:12','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1473826_4019491.jpg','IMG_0426',NULL,0),(476,29,'2168458717791943971',NULL,'2009-07-13 05:29:12','2009-07-13 05:29:12','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1473827_5421764.jpg','IMG_0432',NULL,0),(477,30,'2168458717791940787',NULL,'2009-07-13 05:29:15','2009-07-13 05:29:15','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs031.snc1/2404_54185563639_504883639_1470643_6441191_n.jpg','photo45','--- \n- Jeff Davidson\n',0),(478,30,'2168458717791940784',NULL,'2009-07-13 05:29:15','2009-07-13 05:29:15','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs031.snc1/2404_54185468639_504883639_1470640_3809595_n.jpg','photo451-1','--- \n- Jeff Davidson\n',0),(479,30,'2168458717791940786',NULL,'2009-07-13 05:29:15','2009-07-13 05:29:15','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs031.snc1/2404_54185538639_504883639_1470642_4881317_n.jpg','photo457','--- \n- Jeff Davidson\n',0),(480,30,'2168458717791940785',NULL,'2009-07-13 05:29:15','2009-07-13 05:29:15','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs031.snc1/2404_54185523639_504883639_1470641_7490053_n.jpg','photo505-1','--- \n- Jeff Davidson\n',0),(481,31,'2168458717791919977',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449833_3914380.jpg','IMG_0971',NULL,0),(482,31,'2168458717791919972',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152203639_504883639_1449828_3048286_n.jpg','IMG_0977',NULL,0),(483,31,'2168458717791919967',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152148639_504883639_1449823_3749037_n.jpg','IMG_0980',NULL,0),(484,31,'2168458717791919978',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152283639_504883639_1449834_3725658_n.jpg','IMG_0981',NULL,0),(485,31,'2168458717791919981',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152323639_504883639_1449837_7360309_n.jpg','IMG_0983',NULL,0),(486,31,'2168458717791919976',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449832_5031776.jpg','IMG_0986',NULL,0),(487,31,'2168458717791919969',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449825_611259.jpg','IMG_0997',NULL,0),(488,31,'2168458717791919973',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152223639_504883639_1449829_6421260_n.jpg','IMG_0998',NULL,0),(489,31,'2168458717791919970',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449826_16778.jpg','IMG_0999',NULL,0),(490,31,'2168458717791919965',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152103639_504883639_1449821_1717766_n.jpg','IMG_1000',NULL,0),(491,31,'2168458717791919966',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152133639_504883639_1449822_7016682_n.jpg','IMG_1001',NULL,0),(492,31,'2168458717791919980',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152313639_504883639_1449836_7838232_n.jpg','IMG_1002',NULL,0),(493,31,'2168458717791919968',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449824_3434624.jpg','IMG_1003',NULL,0),(494,31,'2168458717791919971',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449827_8022184.jpg','IMG_1004',NULL,0),(495,31,'2168458717791919982',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449838_7532425.jpg','IMG_1005',NULL,0),(496,31,'2168458717791919975',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2460/77/120/504883639/n504883639_1449831_969054.jpg','IMG_1006',NULL,0),(497,31,'2168458717791919979',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152293639_504883639_1449835_2254975_n.jpg','IMG_1007',NULL,0),(498,31,'2168458717791919987',NULL,'2009-07-13 05:29:18','2009-07-13 05:29:18','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152933639_504883639_1449843_6811632_n.jpg','IMG_0989',NULL,0),(499,32,'2168458717791887402',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417258_1972.jpg','045_45',NULL,0),(500,32,'2168458717791887407',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417263_7634.jpg','047_47',NULL,0),(501,32,'2168458717791887401',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417257_932.jpg','064_64',NULL,0),(502,32,'2168458717791887397',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417253_6857.jpg','086_86',NULL,0),(503,32,'2168458717791887398',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417254_7798.jpg','088_88',NULL,0),(504,32,'2168458717791887406',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417262_5938.jpg','089_89',NULL,0),(505,32,'2168458717791887399',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417255_8777.jpg','090_90',NULL,0),(506,32,'2168458717791887408',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417264_8694.jpg','103_103',NULL,0),(507,32,'2168458717791887403',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417259_3146.jpg','104_104',NULL,0),(508,32,'2168458717791887404',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417260_4091.jpg','105_105',NULL,0),(509,32,'2168458717791887400',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417256_9838.jpg','114_114',NULL,0),(510,32,'2168458717791887405',NULL,'2009-07-13 05:29:21','2009-07-13 05:29:21','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417261_4958.jpg','115_115',NULL,0),(511,33,'2168458717791887190',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216023639_504883639_1417046_8521_n.jpg','004_4',NULL,0),(512,33,'2168458717791887186',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417042_3947.jpg','005_5','--- \n- Keenan Warner\n- Shirley Vivion\n',0),(513,33,'2168458717791887194',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216088639_504883639_1417050_5063_n.jpg','006_6',NULL,0),(514,33,'2168458717791887191',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216033639_504883639_1417047_135_n.jpg','007_7','--- \n- Ryan Edmond\n',0),(515,33,'2168458717791887196',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216118639_504883639_1417052_8732_n.jpg','008_8','--- \n- Ryan Edmond\n',0),(516,33,'2168458717791887184',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417040_2034.jpg','009_9',NULL,0),(517,33,'2168458717791887193',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417049_3663.jpg','010_10',NULL,0),(518,33,'2168458717791887192',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417048_1564.jpg','011_11',NULL,0),(519,33,'2168458717791887188',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216003639_504883639_1417044_6407_n.jpg','012_12','--- \n- Ryan Edmond\n- Linda Nelle Edmond\n',0),(520,33,'2168458717791887183',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51215948639_504883639_1417039_991_n.jpg','013_13',NULL,0),(521,33,'2168458717791887185',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417041_2972.jpg','014_14',NULL,0),(522,33,'2168458717791887187',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1417043_4860.jpg','015_15',NULL,0),(523,33,'2168458717791887195',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216108639_504883639_1417051_7712_n.jpg','016_16',NULL,0),(524,33,'2168458717791887197',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216133639_504883639_1417053_9998_n.jpg','017_17','--- \n- Keenan Warner\n- Linda Nelle Edmond\n- Trevor Edmond\n- Ryan Edmond\n',0),(525,33,'2168458717791887189',NULL,'2009-07-13 05:29:24','2009-07-13 05:29:24','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216013639_504883639_1417045_7546_n.jpg','018_18',NULL,0),(526,34,'2168458717791887310',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417166_1502.jpg','043_43','--- \n- Ryan Edmond\n',0),(527,34,'2168458717791887306',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417162_7114.jpg','044_44',NULL,0),(528,34,'2168458717791887305',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417161_6152.jpg','045_45','--- \n- Ryan Edmond\n',0),(529,34,'2168458717791887307',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417163_8025.jpg','052_52',NULL,0),(530,34,'2168458717791887308',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417164_8962.jpg','053_53','--- \n- Ryan Edmond\n- Andrew Edmond\n',0),(531,34,'2168458717791887309',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417165_440.jpg','054_54','--- \n- Trevor Edmond\n- Seth Warner\n',0),(532,34,'2168458717791887311',NULL,'2009-07-13 05:29:27','2009-07-13 05:29:27','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417167_2888.jpg','057_57',NULL,0),(533,35,'2168458717791887267',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417123_4193.jpg','019_19',NULL,0),(534,35,'2168458717791887269',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417125_6375.jpg','020_20',NULL,0),(535,35,'2168458717791887251',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417107_4868.jpg','021_21',NULL,0),(536,35,'2168458717791887239',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417095_1947.jpg','022_22',NULL,0),(537,35,'2168458717791887295',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417151_5765.jpg','023_23',NULL,0),(538,35,'2168458717791887246',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417102_9269.jpg','024_24',NULL,0),(539,35,'2168458717791887294',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417150_4858.jpg','025_25',NULL,0),(540,35,'2168458717791887296',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417152_7096.jpg','026_26',NULL,0),(541,35,'2168458717791887249',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417105_2732.jpg','027_27',NULL,0),(542,35,'2168458717791887281',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417137_9883.jpg','028_28',NULL,0),(543,35,'2168458717791887280',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417136_8766.jpg','029_29',NULL,0),(544,35,'2168458717791887275',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417131_2987.jpg','030_30',NULL,0),(545,35,'2168458717791887284',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417140_2560.jpg','031_31',NULL,0),(546,35,'2168458717791887266',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417122_2124.jpg','032_32',NULL,0),(547,35,'2168458717791887244',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417100_7089.jpg','033_33',NULL,0),(548,35,'2168458717791887276',NULL,'2009-07-13 05:29:31','2009-07-13 05:29:31','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417132_4267.jpg','034_34',NULL,0),(549,35,'2168458717791887291',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417147_1977.jpg','035_35',NULL,0),(550,35,'2168458717791887293',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417149_3868.jpg','036_36',NULL,0),(551,35,'2168458717791887254',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417110_7826.jpg','037_37',NULL,0),(552,35,'2168458717791887247',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417103_933.jpg','038_38',NULL,0),(553,35,'2168458717791887272',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417128_9989.jpg','039_39',NULL,0),(554,35,'2168458717791887245',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417101_8307.jpg','040_40',NULL,0),(555,35,'2168458717791887279',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417135_7789.jpg','041_41',NULL,0),(556,35,'2168458717791887261',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417117_6439.jpg','042_42',NULL,0),(557,35,'2168458717791887255',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417111_8776.jpg','043_43',NULL,0),(558,35,'2168458717791887273',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417129_1203.jpg','044_44',NULL,0),(559,35,'2168458717791887238',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417094_1068.jpg','045_45',NULL,0),(560,35,'2168458717791887250',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417106_3660.jpg','046_46',NULL,0),(561,35,'2168458717791887264',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417120_9962.jpg','047_47',NULL,0),(562,35,'2168458717791887290',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417146_563.jpg','048_48',NULL,0),(563,35,'2168458717791887241',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417097_3688.jpg','049_49',NULL,0),(564,35,'2168458717791887243',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417099_5995.jpg','050_50',NULL,0),(565,35,'2168458717791887256',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417112_9635.jpg','051_51',NULL,0),(566,35,'2168458717791887297',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417153_8156.jpg','052_52',NULL,0),(567,35,'2168458717791887263',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417119_8663.jpg','053_53',NULL,0),(568,35,'2168458717791887278',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417134_6407.jpg','054_54',NULL,0),(569,35,'2168458717791887292',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417148_2977.jpg','055_55',NULL,0),(570,35,'2168458717791887274',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417130_2085.jpg','056_56',NULL,0),(571,35,'2168458717791887252',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417108_5938.jpg','057_57',NULL,0),(572,35,'2168458717791887257',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417113_1484.jpg','058_58',NULL,0),(573,35,'2168458717791887237',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417093_115.jpg','059_59',NULL,0),(574,35,'2168458717791887242',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417098_4769.jpg','060_60',NULL,0),(575,35,'2168458717791887270',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417126_7687.jpg','061_61',NULL,0),(576,35,'2168458717791887262',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417118_7531.jpg','062_62',NULL,0),(577,35,'2168458717791887282',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417138_740.jpg','063_63',NULL,0),(578,35,'2168458717791887277',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417133_5277.jpg','064_64',NULL,0),(579,35,'2168458717791887286',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417142_4613.jpg','065_65',NULL,0),(580,35,'2168458717791887298',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417154_9489.jpg','066_66',NULL,0),(581,35,'2168458717791887265',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417121_1041.jpg','067_67',NULL,0),(582,35,'2168458717791887289',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417145_9431.jpg','068_68',NULL,0),(583,35,'2168458717791887260',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417116_4655.jpg','069_69',NULL,0),(584,35,'2168458717791887288',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417144_7888.jpg','070_70',NULL,0),(585,35,'2168458717791887259',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417115_3753.jpg','071_71',NULL,0),(586,35,'2168458717791887283',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417139_1694.jpg','072_72',NULL,0),(587,35,'2168458717791887287',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417143_5593.jpg','073_73',NULL,0),(588,35,'2168458717791887240',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417096_2858.jpg','074_74',NULL,0),(589,35,'2168458717791887258',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417114_2817.jpg','075_75',NULL,0),(590,35,'2168458717791887253',NULL,'2009-07-13 05:29:32','2009-07-13 05:29:32','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417109_6850.jpg','076_76',NULL,0),(591,35,'2168458717791887248',NULL,'2009-07-13 05:29:33','2009-07-13 05:29:33','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417104_1844.jpg','077_77',NULL,0),(592,35,'2168458717791887285',NULL,'2009-07-13 05:29:33','2009-07-13 05:29:33','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417141_3632.jpg','078_78',NULL,0),(593,36,'2168458717791887271',NULL,'2009-07-13 05:29:35','2009-07-13 05:29:35','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417127_8559.jpg','164_164','--- \n- Linda Nelle Edmond\n',0),(594,37,'2168458717791886843',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416699_9793.jpg','IMG_1410',NULL,0),(595,37,'2168458717791886850',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416706_6376.jpg','IMG_1411',NULL,0),(596,37,'2168458717791886853',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416709_4402.jpg','IMG_1412',NULL,0),(597,37,'2168458717791886848',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416704_1056.jpg','IMG_1413',NULL,0),(598,37,'2168458717791886838',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416694_2807.jpg','IMG_1414',NULL,0),(599,37,'2168458717791886842',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416698_8431.jpg','IMG_1415',NULL,0),(600,37,'2168458717791886828',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416684_4460.jpg','IMG_1416',NULL,0),(601,37,'2168458717791886841',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416697_6859.jpg','IMG_1417',NULL,0),(602,37,'2168458717791886854',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416710_6416.jpg','IMG_1418',NULL,0),(603,37,'2168458717791886834',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416690_4373.jpg','IMG_1419',NULL,0),(604,37,'2168458717791886839',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416695_3994.jpg','IMG_1420',NULL,0),(605,37,'2168458717791886835',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416691_6000.jpg','IMG_1421',NULL,0),(606,37,'2168458717791886836',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416692_7698.jpg','IMG_1422',NULL,0),(607,37,'2168458717791886830',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416686_6707.jpg','IMG_1423',NULL,0),(608,37,'2168458717791886845',NULL,'2009-07-13 05:29:38','2009-07-13 05:29:38','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416701_3738.jpg','IMG_1424','--- \n- Linda Nelle Edmond\n',0),(609,37,'2168458717791886855',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416711_9340.jpg','IMG_1425','--- \n- Linda Nelle Edmond\n',0),(610,37,'2168458717791886829',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416685_5459.jpg','IMG_1426',NULL,0),(611,37,'2168458717791886849',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416705_4114.jpg','IMG_1427',NULL,0),(612,37,'2168458717791886840',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416696_5317.jpg','IMG_1428',NULL,0),(613,37,'2168458717791886852',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416708_1331.jpg','IMG_1431',NULL,0),(614,37,'2168458717791886831',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416687_9164.jpg','IMG_1432',NULL,0),(615,37,'2168458717791886833',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416689_1639.jpg','IMG_1433',NULL,0),(616,37,'2168458717791886837',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416693_9740.jpg','IMG_1434',NULL,0),(617,37,'2168458717791886846',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416702_5285.jpg','IMG_1435',NULL,0),(618,37,'2168458717791886844',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416700_1397.jpg','IMG_1436',NULL,0),(619,37,'2168458717791886832',NULL,'2009-07-13 05:29:39','2009-07-13 05:29:39','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416688_487.jpg','IMG_1437',NULL,0),(620,38,'2168458717791886581',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186293639_504883639_1416437_1447_n.jpg','IMG_0919',NULL,0),(621,38,'2168458717791886594',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416450_9126.jpg','IMG_0926',NULL,0),(622,38,'2168458717791886593',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186468639_504883639_1416449_7905_n.jpg','IMG_0930','--- \n- Linda Nelle Edmond\n',0),(623,38,'2168458717791886598',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186538639_504883639_1416454_7397_n.jpg','IMG_0931','--- \n- Linda Nelle Edmond\n',0),(624,38,'2168458717791886589',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416445_1133.jpg','IMG_0934','--- \n- Linda Nelle Edmond\n',0),(625,38,'2168458717791886584',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186338639_504883639_1416440_4974_n.jpg','IMG_0935','--- \n- Linda Nelle Edmond\n',0),(626,38,'2168458717791886592',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186453639_504883639_1416448_6528_n.jpg','IMG_0936',NULL,0),(627,38,'2168458717791886580',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186283639_504883639_1416436_80_n.jpg','IMG_0937',NULL,0),(628,38,'2168458717791886587',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186383639_504883639_1416443_8678_n.jpg','IMG_0941',NULL,0),(629,38,'2168458717791886591',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416447_3638.jpg','IMG_0944',NULL,0),(630,38,'2168458717791886597',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416453_5963.jpg','IMG_0945',NULL,0),(631,38,'2168458717791886583',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416439_3822.jpg','IMG_0946','--- \n- Linda Nelle Edmond\n',0),(632,38,'2168458717791886586',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186363639_504883639_1416442_7093_n.jpg','IMG_0947',NULL,0),(633,38,'2168458717791886579',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186268639_504883639_1416435_8536_n.jpg','IMG_0951',NULL,0),(634,38,'2168458717791886590',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416446_2090.jpg','IMG_0956','--- \n- Linda Nelle Edmond\n',0),(635,38,'2168458717791886588',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416444_9897.jpg','IMG_0957','--- \n- Linda Nelle Edmond\n',0),(636,38,'2168458717791886596',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416452_3975.jpg','IMG_0959',NULL,0),(637,38,'2168458717791886595',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416451_1263.jpg','IMG_0960',NULL,0),(638,38,'2168458717791886600',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186558639_504883639_1416456_9783_n.jpg','IMG_0961',NULL,0),(639,38,'2168458717791886599',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-h.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186548639_504883639_1416455_8834_n.jpg','IMG_0962',NULL,0),(640,38,'2168458717791886601',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186573639_504883639_1416457_663_n.jpg','IMG_0964',NULL,0),(641,38,'2168458717791886582',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416438_2506.jpg','IMG_0965',NULL,0),(642,38,'2168458717791886585',NULL,'2009-07-13 05:29:42','2009-07-13 05:29:42','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51186353639_504883639_1416441_5925_n.jpg','IMG_0966',NULL,0),(643,39,'2168458717791856986',NULL,'2009-07-13 05:29:45','2009-07-13 05:29:45','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1386842_2987.jpg','IMG_0905','--- \n- Robin Schauer\n',0),(644,39,'2168458717791856984',NULL,'2009-07-13 05:29:45','2009-07-13 05:29:45','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1386840_9824.jpg','IMG_0906',NULL,0),(645,39,'2168458717791856983',NULL,'2009-07-13 05:29:45','2009-07-13 05:29:45','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1386839_8646.jpg','IMG_0909','--- \n- Robin Schauer\n',0),(646,39,'2168458717791856985',NULL,'2009-07-13 05:29:45','2009-07-13 05:29:45','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1386841_1426.jpg','IMG_0910','--- \n- Robin Schauer\n',0),(647,40,'2168458717791798566',NULL,'2009-07-13 05:29:47','2009-07-13 05:29:47','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1328422_4249.jpg','IMG_0160.JPG',NULL,0),(648,40,'2168458717791798567',NULL,'2009-07-13 05:29:47','2009-07-13 05:29:47','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1328423_5758.jpg','IMG_0161.JPG',NULL,0),(649,41,'2168458717791763209',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293065_2545.jpg','Robin and Jack','--- \n- Robin Schauer\n',0),(650,41,'2168458717791763210',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293066_3655.jpg','Robin and Jack','--- \n- Robin Schauer\n',0),(651,41,'2168458717791763211',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293067_4643.jpg','Robin and Lena','--- \n- Robin Schauer\n',0),(652,41,'2168458717791763212',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293068_6945.jpg','Robin and Lena','--- \n- Robin Schauer\n',0),(653,41,'2168458717791763213',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293069_8312.jpg','Robin and Lena','--- \n- Robin Schauer\n',0),(654,41,'2168458717791763214',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293070_9409.jpg','Jack Monster Attacking Robin and Lena','--- \n- Robin Schauer\n',0),(655,41,'2168458717791763215',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293071_973.jpg','Lena!  on the gondola',NULL,0),(656,41,'2168458717791763216',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293072_1988.jpg','Jack on the gondola!',NULL,0),(657,41,'2168458717791763217',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293073_2928.jpg','Getting ready to go tubing!','--- \n- Robin Schauer\n',0),(658,41,'2168458717791763218',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293074_4049.jpg','Getting ready to go tubing!','--- \n- Robin Schauer\n',0),(659,41,'2168458717791763219',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293075_5302.jpg','Getting ready to go tubing!','--- \n- Robin Schauer\n',0),(660,41,'2168458717791763220',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293076_6568.jpg','robin and lena','--- \n- Robin Schauer\n',0),(661,41,'2168458717791763221',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293077_9047.jpg','robin and lena','--- \n- Robin Schauer\n',0),(662,41,'2168458717791763222',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293078_213.jpg','Jack and Daddy-o',NULL,0),(663,41,'2168458717791763223',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293079_1225.jpg','Jack and Daddy-o',NULL,0),(664,41,'2168458717791763224',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293080_2401.jpg','Jack and Lena',NULL,0),(665,41,'2168458717791763225',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293081_3379.jpg','Jack and Lena',NULL,0),(666,41,'2168458717791763226',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293082_4290.jpg','Jack and Lena',NULL,0),(667,41,'2168458717791763227',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293083_5219.jpg','Jack Snowman',NULL,0),(668,41,'2168458717791763228',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293084_6136.jpg','Jack and Lena',NULL,0),(669,41,'2168458717791763229',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293085_7092.jpg','Lena!',NULL,0),(670,41,'2168458717791763230',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293086_7984.jpg','Jack and Lena',NULL,0),(671,41,'2168458717791763231',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293087_8735.jpg','Jack and Lena playing in the snow',NULL,0),(672,41,'2168458717791763232',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293088_9800.jpg','Jack Skiing!  On my old skiis from when I was a kid',NULL,0),(673,41,'2168458717791763233',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293089_708.jpg','Jack Skiing!  On my old skiis from when I was a kid',NULL,0),(674,41,'2168458717791763234',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293090_1464.jpg','Jack Skiing!  On my old skiis from when I was a kid',NULL,0),(675,41,'2168458717791763235',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293091_2580.jpg','Jack and Lena',NULL,0),(676,41,'2168458717791763236',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293092_3390.jpg','Jack!  Swimming!',NULL,0),(677,41,'2168458717791763237',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293093_4376.jpg','Lena Swimming!',NULL,0),(678,41,'2168458717791763238',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293094_5146.jpg','Jack Swimming :)',NULL,0),(679,41,'2168458717791763239',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293095_6271.jpg','Jack being a dork, like his dad',NULL,0),(680,41,'2168458717791763240',NULL,'2009-07-13 05:29:51','2009-07-13 05:29:51','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293096_7163.jpg','Jack being a dork, like his dad',NULL,0),(681,41,'2168458717791763241',NULL,'2009-07-13 05:29:52','2009-07-13 05:29:52','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v2114/77/120/504883639/n504883639_1293097_8101.jpg','Jack took this picture','--- \n- Robin Schauer\n',0),(682,42,'2168458717791736987',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266843_3033.jpg','He didn\'t like it at first, but he couldn\'t stop after a while!',NULL,0),(683,42,'2168458717791736988',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266844_4874.jpg','He totally skated by himself for an hour or more.',NULL,0),(684,42,'2168458717791736989',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266845_6272.jpg','Bowling with friends!',NULL,0),(685,42,'2168458717791736990',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-g.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266846_7931.jpg','Little monkey man.  Lena says JACK GET DOWN!',NULL,0),(686,42,'2168458717791736991',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-h.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266847_9882.jpg','',NULL,0),(687,42,'2168458717791736992',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266848_1574.jpg','Robin wrestling',NULL,0),(688,42,'2168458717791736993',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266849_3281.jpg','Robin wrestling, Jack is pwning her.',NULL,0),(689,42,'2168458717791736994',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266850_6175.jpg','Robin wrestling',NULL,0),(690,42,'2168458717791736995',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-d.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266851_7965.jpg','Robin wrestling',NULL,0),(691,42,'2168458717791736996',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-e.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266852_9441.jpg','Robin wrestling',NULL,0),(692,42,'2168458717791736997',NULL,'2009-07-13 05:29:54','2009-07-13 05:29:54','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v1922/77/120/504883639/n504883639_1266853_837.jpg','Robin wrestling, and about to pass out from getting her butt kicked by three kids.',NULL,0),(693,43,'2168458717791638090',NULL,'2009-07-13 05:29:57','2009-07-13 05:29:57','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1167946_9915.jpg','',NULL,0),(694,43,'2168458717791638091',NULL,'2009-07-13 05:29:57','2009-07-13 05:29:57','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1167947_1058.jpg','',NULL,0),(695,43,'2168458717791638092',NULL,'2009-07-13 05:29:57','2009-07-13 05:29:57','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1167948_1976.jpg','',NULL,0),(696,44,'2168458717791560985',NULL,'2009-07-13 05:29:59','2009-07-13 05:29:59','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090841_7606.jpg','Burning Man',NULL,0),(697,44,'2168458717791560986',NULL,'2009-07-13 05:29:59','2009-07-13 05:29:59','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090842_187.jpg','Burning Man',NULL,0),(698,44,'2168458717791560988',NULL,'2009-07-13 05:29:59','2009-07-13 05:29:59','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090844_6862.jpg','Raspberries Daddy-o!',NULL,0),(699,44,'2168458717791560989',NULL,'2009-07-13 05:29:59','2009-07-13 05:29:59','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090845_8435.jpg','',NULL,0),(700,44,'2168458717791560990',NULL,'2009-07-13 05:29:59','2009-07-13 05:29:59','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090846_9751.jpg','Skyride at Puyallup Fair',NULL,0),(701,44,'2168458717791560991',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090847_785.jpg','Skyride at Puyallup Fair',NULL,0),(702,44,'2168458717791560992',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090848_1661.jpg','',NULL,0),(703,44,'2168458717791560993',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090849_5596.jpg','Borfylo resting up',NULL,0),(704,44,'2168458717791560994',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090850_7251.jpg','',NULL,0),(705,44,'2168458717791560995',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090851_8218.jpg','YUM!',NULL,0),(706,44,'2168458717791560996',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090852_9608.jpg','Way Station with Ryan',NULL,0),(707,44,'2168458717791560997',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090853_1172.jpg','LEGOLAND!',NULL,0),(708,44,'2168458717791560998',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090854_2556.jpg','',NULL,0),(709,44,'2168458717791560999',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090855_3940.jpg','','--- \n- Keenan Warner\n',0),(710,44,'2168458717791561000',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090856_6401.jpg','',NULL,0),(711,44,'2168458717791561001',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090857_7598.jpg','',NULL,0),(712,44,'2168458717791561002',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1090858_9303.jpg','',NULL,0),(713,44,'2168458717791599700',NULL,'2009-07-13 05:30:00','2009-07-13 05:30:00','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1129556_2114.jpg','Jack took this picture of me',NULL,0),(714,45,'2168458717791554187',NULL,'2009-07-13 05:30:02','2009-07-13 05:30:02','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1084043_5557.jpg','Trevor teaching Keenan Facebook','--- \n- Keenan Warner\n- Trevor Edmond\n',0),(715,45,'2168458717791554188',NULL,'2009-07-13 05:30:02','2009-07-13 05:30:02','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1084044_8976.jpg','',NULL,0),(716,46,'2168458717791463675',NULL,'2009-07-13 05:30:05','2009-07-13 05:30:05','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993531_7252.jpg','Watching the Parade',NULL,0),(717,46,'2168458717791463676',NULL,'2009-07-13 05:30:05','2009-07-13 05:30:05','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993532_922.jpg','',NULL,0),(718,46,'2168458717791463684',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993540_4201.jpg','',NULL,0),(719,46,'2168458717791463686',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-g.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993542_6943.jpg','Something scary out there!',NULL,0),(720,46,'2168458717791463687',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993543_9312.jpg','',NULL,0),(721,46,'2168458717791463688',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993544_1453.jpg','',NULL,0),(722,46,'2168458717791463689',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993545_4528.jpg','This kid got some serious haul',NULL,0),(723,46,'2168458717791463690',NULL,'2009-07-13 05:30:06','2009-07-13 05:30:06','http://photos-c.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_993546_7514.jpg','',NULL,0),(724,47,'2168458717791461811',NULL,'2009-07-13 05:30:08','2009-07-13 05:30:08','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v360/77/120/504883639/n504883639_991667_9297.jpg','Yeah, super dork',NULL,0);
/*!40000 ALTER TABLE `backup_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_sites`
--

DROP TABLE IF EXISTS `backup_sites`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_sites` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_sites_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_sites`
--

LOCK TABLES `backup_sites` WRITE;
/*!40000 ALTER TABLE `backup_sites` DISABLE KEYS */;
INSERT INTO `backup_sites` VALUES (1,'facebook',NULL);
/*!40000 ALTER TABLE `backup_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_source_days`
--

DROP TABLE IF EXISTS `backup_source_days`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_source_days` (
  `id` int(11) NOT NULL auto_increment,
  `backup_day` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `status_id` int(11) NOT NULL default '0',
  `in_progress` tinyint(1) NOT NULL default '0',
  `backup_source_id` int(11) default NULL,
  `skip` tinyint(1) NOT NULL default '0',
  `skip_count` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `backup_dates` (`backup_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_source_days`
--

LOCK TABLES `backup_source_days` WRITE;
/*!40000 ALTER TABLE `backup_source_days` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_source_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_source_jobs`
--

DROP TABLE IF EXISTS `backup_source_jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_source_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `backup_job_id` int(11) default NULL,
  `size` int(11) default NULL,
  `days` int(11) default NULL,
  `created_at` datetime default NULL,
  `status` int(11) NOT NULL default '0',
  `messages` text,
  `backup_source_id` int(11) default NULL,
  `error_messages` text,
  `finished_at` datetime default NULL,
  `percent_complete` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `backup_job_source` (`backup_job_id`,`backup_source_id`),
  KEY `index_backup_source_jobs_on_backup_job_id` (`backup_job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_source_jobs`
--

LOCK TABLES `backup_source_jobs` WRITE;
/*!40000 ALTER TABLE `backup_source_jobs` DISABLE KEYS */;
INSERT INTO `backup_source_jobs` VALUES (1,100,NULL,NULL,'2009-07-13 05:27:34',1,NULL,1,NULL,'2009-07-13 05:30:32',100);
/*!40000 ALTER TABLE `backup_source_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_sources`
--

DROP TABLE IF EXISTS `backup_sources`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_sources` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `auth_login` varchar(255) default NULL,
  `auth_password` varchar(255) default NULL,
  `rss_url` varchar(255) default NULL,
  `auth_confirmed` tinyint(1) NOT NULL default '0',
  `auth_error` varchar(255) default NULL,
  `last_backup_at` datetime default NULL,
  `latest_day_backed_up` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_id` int(11) default NULL,
  `backup_site_id` int(11) default NULL,
  `disabled` tinyint(1) NOT NULL default '0',
  `skip_video` tinyint(1) NOT NULL default '0',
  `earliest_day_backed_up` date default NULL,
  `needs_initial_scan` tinyint(1) NOT NULL default '1',
  `last_login_attempt_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_backup_site` (`user_id`,`backup_site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_sources`
--

LOCK TABLES `backup_sources` WRITE;
/*!40000 ALTER TABLE `backup_sources` DISABLE KEYS */;
INSERT INTO `backup_sources` VALUES (1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,'2009-07-13 05:27:33','2009-07-13 05:27:34',1,1,0,0,NULL,1,'2009-07-13 05:27:34','2009-07-13 05:27:34');
/*!40000 ALTER TABLE `backup_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_states`
--

DROP TABLE IF EXISTS `backup_states`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `backup_states` (
  `id` int(11) NOT NULL auto_increment,
  `last_successful_backup_at` datetime default NULL,
  `last_failed_backup_at` datetime default NULL,
  `last_backup_finished_at` datetime default NULL,
  `in_progress` tinyint(1) default NULL,
  `disabled` tinyint(1) default NULL,
  `last_errors` text,
  `last_messages` text,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_backup_job_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_states_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_states`
--

LOCK TABLES `backup_states` WRITE;
/*!40000 ALTER TABLE `backup_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `global` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_categories_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorizations`
--

DROP TABLE IF EXISTS `categorizations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `categorizations` (
  `id` int(11) NOT NULL auto_increment,
  `category_id` int(11) NOT NULL,
  `categorizable_id` int(11) default NULL,
  `categorizable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_categorizations_on_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `categorizations`
--

LOCK TABLES `categorizations` WRITE;
/*!40000 ALTER TABLE `categorizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circles`
--

DROP TABLE IF EXISTS `circles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `circles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_circles_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `circles`
--

LOCK TABLES `circles` WRITE;
/*!40000 ALTER TABLE `circles` DISABLE KEYS */;
/*!40000 ALTER TABLE `circles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `commentable_id` int(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `user_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `index_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_emails`
--

DROP TABLE IF EXISTS `contact_emails`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact_emails` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `contact_emails`
--

LOCK TABLES `contact_emails` WRITE;
/*!40000 ALTER TABLE `contact_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_accessors`
--

DROP TABLE IF EXISTS `content_accessors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `content_accessors` (
  `id` int(11) NOT NULL auto_increment,
  `content_authorization_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `circle_id` int(11) default NULL,
  `permissions` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_content_accessors_on_content_authorization_id` (`content_authorization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `content_accessors`
--

LOCK TABLES `content_accessors` WRITE;
/*!40000 ALTER TABLE `content_accessors` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_accessors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_authorizations`
--

DROP TABLE IF EXISTS `content_authorizations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `content_authorizations` (
  `id` int(11) NOT NULL auto_increment,
  `authorizable_id` int(11) default NULL,
  `authorizable_type` varchar(255) default NULL,
  `privacy_level` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `content_authorizations`
--

LOCK TABLES `content_authorizations` WRITE;
/*!40000 ALTER TABLE `content_authorizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_authorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contents` (
  `id` int(11) NOT NULL auto_increment,
  `size` int(11) NOT NULL default '0',
  `type` varchar(255) NOT NULL default 'Document',
  `title` varchar(255) NOT NULL default 'Document',
  `filename` varchar(255) NOT NULL default 'Document',
  `thumbnail` varchar(255) default NULL,
  `bitrate` varchar(255) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_id` int(11) NOT NULL default '0',
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `taken_at` datetime default NULL,
  `duration` varchar(255) default NULL,
  `version` int(11) default NULL,
  `processing_error_message` varchar(255) default NULL,
  `cdn_url` varchar(255) default NULL,
  `description` text,
  `fps` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `is_recording` tinyint(1) NOT NULL default '0',
  `s3_key` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `official_name` varchar(255) default NULL,
  `alpha_2_code` varchar(255) default NULL,
  `alpha_3_code` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decorations`
--

DROP TABLE IF EXISTS `decorations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `decorations` (
  `id` int(11) NOT NULL auto_increment,
  `content_id` int(11) NOT NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `decoratable_type` varchar(255) NOT NULL,
  `decoratable_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_decorations_on_content_id` (`content_id`),
  KEY `index_decorations_on_polymorph` (`decoratable_id`,`decoratable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `decorations`
--

LOCK TABLES `decorations` WRITE;
/*!40000 ALTER TABLE `decorations` DISABLE KEYS */;
/*!40000 ALTER TABLE `decorations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deleted_accounts`
--

DROP TABLE IF EXISTS `deleted_accounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `deleted_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `full_domain` varchar(255) default NULL,
  `subscription_discount_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `deleted_accounts`
--

LOCK TABLES `deleted_accounts` WRITE;
/*!40000 ALTER TABLE `deleted_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `deleted_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elements`
--

DROP TABLE IF EXISTS `elements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `elements` (
  `id` int(11) NOT NULL auto_increment,
  `story_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `position` int(11) default NULL,
  `message` text,
  `title` varchar(255) default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_elements_on_story_id` (`story_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `elements`
--

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;
/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_contents`
--

DROP TABLE IF EXISTS `email_contents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `email_contents` (
  `id` int(11) NOT NULL auto_increment,
  `backup_email_id` int(11) NOT NULL,
  `bytes` int(11) NOT NULL default '0',
  `s3_key` varchar(255) default NULL,
  `contents` blob,
  PRIMARY KEY  (`id`),
  KEY `index_email_contents_on_backup_email_id` (`backup_email_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `email_contents`
--

LOCK TABLES `email_contents` WRITE;
/*!40000 ALTER TABLE `email_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facebook_contents`
--

DROP TABLE IF EXISTS `facebook_contents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `facebook_contents` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `friends` text,
  `groups` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_facebook_contents_on_profile_id` (`profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `facebook_contents`
--

LOCK TABLES `facebook_contents` WRITE;
/*!40000 ALTER TABLE `facebook_contents` DISABLE KEYS */;
INSERT INTO `facebook_contents` VALUES (1,1,'--- \n- Thomas James\n- Daniel Lydiard\n- Adam MacBeth\n- Cassie Wallender\n- Tony Wright\n- Asha Sophia\n- Sean Jordan\n- Laura McNamara\n- Michelle Lecompte\n- Bullet Mehta\n- Jesse Driskill\n- Andrew Hermitage\n- Ernst Gmeiner\n- Marie Burns Garman\n- Marija Zmiarovich\n- Christina Todd Mallet\n- Kindra Howard Orsenigo\n- Jim DeLeskie\n- Federico Vieto\n- Brent Dreyer\n- Kelly Smith\n- Jorim R Gray\n- Diane Devine\n- Jeff Terrell\n- Jeff Patterson\n- Molly Meggyesy\n- Terri Esterly Pollard\n- Erin Zane Levin\n- David M. Baker\n- Nikolas Leyde\n- Chononita Fabian Piorkowsky\n- Lydia Ranger Richman\n- Tony Taylor\n- Josh Rebel\n- Thomas Kim\n- Rachel McLennan\n- Tim Gerber\n- Aron Higgins\n- William Velimir Pavichevich\n- Greg P. Smith\n- Eric Rogers\n- Randy Turner\n- Brandon Bozzi\n- Darn It\n- John Cornelison\n- Emily Stogsdill\n- Charlo Barbosa\n- Frederick Woodruff\n- Jacque Garite Krum\n- Aexis Liester\n- Rosemary Luellen Geelan\n- Anthony Valenzuela\n- Elph Stone\n- Janna Ignatow\n- Lisa Kristensen\n- Bryce Gifford\n- Keith Boudreau\n- Chris Terp\n- Scott Golembiewski\n- Brittany Nicole Owensby\n- Pamn Aspiri\n- Ian Eisenberg\n- Robert Williams\n- Mark Madsen\n- Rizki Arnosa\n- Tara Brook\n- Benetton Fe.\n- Dushan Pavichevich\n- Angie Moore\n- Kirrilee Jacobi\n- Marc Mauger\n- John E. Skidmore\n- Heidi Bentz\n- Jeff Davidson\n- Asa Williams\n- Darryl Caldwell\n- Shawn Reinas\n- Michelle Eikrem\n- Teresa Savage\n- Shirley Vivion\n- Trevor Edmond\n- Nicole Zaferes Gustad\n- Heidi Carpenter\n- Greg Garite\n- Curt Alan Enos\n- Mike Fink\n- Lisa Nourse\n- Matt Wilson\n- Tony Gerber\n- Nicholas Black\n- Will Cronk\n- Wendy Cafferky Niles\n- Kristie Spilios\n- Ryan Edmond\n- Steve Sowers\n- Robin Schauer\n- Thom Jenkins\n- Silas J. Warner\n- Michael Wong\n- George Skip Ekins\n- Jeffrey Lloyd Snader\n- Seth Warner\n- Red Bike\n- Phil Moyer\n- Zachary Lark\n- Jennifer Robbins Curtis\n- Nickolaus Smith\n- Stephanie Patrick Richardson\n- Risa Roberts Warner\n- Eric Freund\n- Work Truck Malt Liquor\n- Krista Martin Foust\n- Niki Green\n- Hendra Nicholas\n- Doug Boudreau\n- Hoby Van Hoose\n- Rebecca O\'Connor\n- Kassi Osterholtz\n- Anna Kinsler\n- Amy Glamser\n- Jennifer Eikrem\n- Sam Templeton\n- Brodie Carroll\n- Troy Brocato\n- Dawn Hunter\n- Deidra Johnson\n- Lois Hall Preisendorf\n- Erin Rollins Pletsch\n- Janie Spencer\n- Steve Chadwick\n- Erica Legum\n- Jennifer Gillette\n- Gregory J Geelan\n- Jason Schauer\n- Keenan Warner\n- Jamie Warter\n- Colton La Zar\n- Kindel Glamser\n- Steven Ohmert\n- Scott Garite\n- Sarah Hood\n- Linda Nelle Edmond\n- Michael Kunjara\n- Pedro Margate\n- Amanda Dunker\n- Serena A. Warner\n- Sonny Julian\n- Simon Hedley\n','--- \n- Geography\n- Common Interest\n- Entertainment &amp; Arts\n- Internet &amp; Technology\n- Business\n- Music\n- Common Interest\n- Business\n- Common Interest\n- Geography\n- Common Interest\n- Just for Fun\n- Common Interest\n- Just for Fun\n- Entertainment &amp; Arts\n- Common Interest\n- Common Interest\n- Common Interest\n- Common Interest\n- Student Groups\n- Geography\n- Business\n- Organizations\n- Geography\n- Entertainment &amp; Arts\n- Organizations\n- Sports &amp; Recreation\n- Internet &amp; Technology\n- Internet &amp; Technology\n- Business\n- Common Interest\n- Common Interest\n','2009-07-13 05:27:36','2009-07-13 05:27:38');
/*!40000 ALTER TABLE `facebook_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `families`
--

DROP TABLE IF EXISTS `families`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `families` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `birthdate` datetime default NULL,
  `living` tinyint(1) default '1',
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `family_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_families_on_profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `families`
--

LOCK TABLES `families` WRITE;
/*!40000 ALTER TABLE `families` DISABLE KEYS */;
/*!40000 ALTER TABLE `families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_entries`
--

DROP TABLE IF EXISTS `feed_entries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `feed_entries` (
  `id` int(11) NOT NULL auto_increment,
  `feed_id` int(11) NOT NULL,
  `author` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `summary` text,
  `rss_content` text,
  `url_content` text,
  `categories` text,
  `url` varchar(255) default NULL,
  `published_at` datetime default NULL,
  `guid` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `feed_guid` (`feed_id`,`guid`),
  KEY `index_feed_entries_on_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `feed_entries`
--

LOCK TABLES `feed_entries` WRITE;
/*!40000 ALTER TABLE `feed_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feeds`
--

DROP TABLE IF EXISTS `feeds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `feeds` (
  `id` int(11) NOT NULL auto_increment,
  `backup_source_id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `feed_url_s` varchar(255) default NULL,
  `etag` varchar(255) default NULL,
  `last_modified` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_feeds_on_backup_source_id` (`backup_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `feeds`
--

LOCK TABLES `feeds` WRITE;
/*!40000 ALTER TABLE `feeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `feeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest_invitations`
--

DROP TABLE IF EXISTS `guest_invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `guest_invitations` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) NOT NULL,
  `circle_id` int(11) default NULL,
  `email` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `contact_method` varchar(255) default NULL,
  `sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `attempts` int(11) NOT NULL default '0',
  `emergency_contact` tinyint(1) default NULL,
  `token` varchar(255) default NULL,
  `send_on` datetime default NULL,
  `status` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `guest_invitations`
--

LOCK TABLES `guest_invitations` WRITE;
/*!40000 ALTER TABLE `guest_invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `guest_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitations`
--

DROP TABLE IF EXISTS `invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `invitations` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) NOT NULL,
  `recipient_email` varchar(255) default NULL,
  `token` varchar(255) default NULL,
  `sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_invitations_on_sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invitations`
--

LOCK TABLES `invitations` WRITE;
/*!40000 ALTER TABLE `invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `company` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `start_at` date default NULL,
  `end_at` date default NULL,
  `notes` text,
  PRIMARY KEY  (`id`),
  KEY `index_jobs_on_profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_conditions`
--

DROP TABLE IF EXISTS `medical_conditions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medical_conditions` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `diagnosis` text,
  `treatment` text,
  `notes` text,
  `diagnosis_date` datetime default NULL,
  `treatment_date` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medical_conditions`
--

LOCK TABLES `medical_conditions` WRITE;
/*!40000 ALTER TABLE `medical_conditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicals`
--

DROP TABLE IF EXISTS `medicals`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `medicals` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `blood_type` varchar(255) default NULL,
  `disorder` varchar(255) default NULL,
  `physician_name` varchar(255) default NULL,
  `physician_phone` varchar(255) default NULL,
  `dentist_name` varchar(255) default NULL,
  `dentist_phone` varchar(255) default NULL,
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `medicals`
--

LOCK TABLES `medicals` WRITE;
/*!40000 ALTER TABLE `medicals` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  `message` text NOT NULL,
  `category_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_messages_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_emails`
--

DROP TABLE IF EXISTS `notify_emails`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notify_emails` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `sent_at` datetime default NULL,
  `referrer` text,
  `keywords` text,
  PRIMARY KEY  (`id`),
  KEY `index_notify_emails_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `notify_emails`
--

LOCK TABLES `notify_emails` WRITE;
/*!40000 ALTER TABLE `notify_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `notify_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_associations`
--

DROP TABLE IF EXISTS `open_id_authentication_associations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL auto_increment,
  `issued` int(11) default NULL,
  `lifetime` int(11) default NULL,
  `handle` varchar(255) default NULL,
  `assoc_type` varchar(255) default NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `open_id_authentication_associations`
--

LOCK TABLES `open_id_authentication_associations` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_nonces`
--

DROP TABLE IF EXISTS `open_id_authentication_nonces`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) default NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `open_id_authentication_nonces`
--

LOCK TABLES `open_id_authentication_nonces` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_nonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_nonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `remote_ip` varchar(255) default NULL,
  `token` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_password_resets_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_numbers`
--

DROP TABLE IF EXISTS `phone_numbers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `phone_numbers` (
  `id` int(11) NOT NULL auto_increment,
  `phoneable_id` int(11) NOT NULL,
  `phoneable_type` varchar(255) NOT NULL,
  `phone_type` varchar(255) NOT NULL,
  `prefix` varchar(255) default NULL,
  `area_code` varchar(255) default NULL,
  `number` varchar(255) default NULL,
  `extension` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `phone_numbers`
--

LOCK TABLES `phone_numbers` WRITE;
/*!40000 ALTER TABLE `phone_numbers` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_thumbnails`
--

DROP TABLE IF EXISTS `photo_thumbnails`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `photo_thumbnails` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `photo_thumbnails`
--

LOCK TABLES `photo_thumbnails` WRITE;
/*!40000 ALTER TABLE `photo_thumbnails` DISABLE KEYS */;
/*!40000 ALTER TABLE `photo_thumbnails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_schema_info`
--

DROP TABLE IF EXISTS `plugin_schema_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `plugin_schema_info`
--

LOCK TABLES `plugin_schema_info` WRITE;
/*!40000 ALTER TABLE `plugin_schema_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `height` varchar(255) default NULL,
  `weight` varchar(255) default NULL,
  `race` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `religion` varchar(255) default NULL,
  `political_views` varchar(255) default NULL,
  `sexual_orientation` varchar(255) default NULL,
  `nickname` varchar(255) default NULL,
  `ethnicity` varchar(255) default NULL,
  `children` varchar(255) default NULL,
  `death_date` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `facebook_data` text,
  PRIMARY KEY  (`id`),
  KEY `index_profiles_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 05:27:33','2009-07-13 05:27:35','--- \n:affiliations: \n- !ruby/object:Facebooker::Affiliation \n  name: Seattle, WA\n  nid: \"67108883\"\n  populated: true\n  status: \"\"\n  type: region\n  year: \"0\"\n:work_history: \n- !ruby/object:Facebooker::WorkInfo \n  company_name: Andrew Edmond Consulting\n  description: \"\"\n  end_date: \"\"\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: Managing Partner\n  start_date: 0000-00\n- !ruby/object:Facebooker::WorkInfo \n  company_name: GridNetworks, Inc\n  description: \"\"\n  end_date: 2007-12\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: Chief Architect\n  start_date: 2004-12\n- !ruby/object:Facebooker::WorkInfo \n  company_name: Accretive Technologies Inc.\n  description: \"\"\n  end_date: 2001-04\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: CEO\n  start_date: 1997-06\n:is_app_user: \"1\"\n:pic_big_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=d535f7591dabe7f236ac9d739680046f&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fn504883639_8563.jpg&amp;v=5\n:education_history: \n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - Computer Science\n  degree: \"\"\n  name: University of Southern California\n  populated: true\n  year: \"1993\"\n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - Botany\n  degree: \"\"\n  name: University of Wyoming\n  populated: true\n  year: \"1997\"\n:hometown_location: !ruby/object:Facebooker::Location \n  city: Valencia\n  country: United States\n  populated: true\n  state: California\n  zip: {}\n\n:timezone: \"-7\"\n:profile_url: http://www.facebook.com/nerolabs\n:sex: male\n:tv: \"\"\n:pic_small_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=3f918ff7bc167e5c80cd33dafe2c5165&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Ft504883639_8563.jpg&amp;v=5\n:meeting_for: \n- Friendship\n- Networking\n:about_me: \"\"\n:proxied_email: apps+109701370954.504883639.ac7a5eda699ebc4478f6455ac41b40a0@proxymail.facebook.com\n:pic_square: http://profile.ak.fbcdn.net/v230/1085/109/q504883639_8563.jpg\n:religion: Spiritual but not religious\n:profile_update_time: \"0\"\n:pic_square_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=1122252be1b7b8da6833a8b1d616c545&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fq504883639_8563.jpg&amp;v=5\n:interests: \"\"\n:first_name: Andrew\n:wall_count: \"64\"\n:email_hashes: []\n\n:pic: http://profile.ak.fbcdn.net/v230/1085/109/s504883639_8563.jpg\n:last_name: Edmond\n:notes_count: \n:meeting_sex: \n- female\n:current_location: \n:has_added_app: \"1\"\n:significant_other_id: \n:political: Libertarian\n:allowed_restrictions: alcohol\n:locale: en_US\n:activities: \"\"\n:hs_info: !ruby/object:Facebooker::EducationInfo::HighschoolInfo \n  grad_year: \"1991\"\n  hs1_id: \"2272\"\n  hs1_name: William S. Hart Senior High\n  hs2_id: \"0\"\n  hs2_name: {}\n\n  populated: true\n:name: Andrew Edmond\n:pic_small: http://profile.ak.fbcdn.net/v230/1085/109/t504883639_8563.jpg\n:books: Wheel Of Time\n:music: \"\"\n:quotes: \"\"\n:pic_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=86bcafc985b603fb8882af90370286e6&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fs504883639_8563.jpg&amp;v=5\n:birthday: June 22, 1973\n:movies: The Thing (1982), Godfather, The Notebook, Across the Universe, Fight Club\n:pic_big: http://profile.ak.fbcdn.net/v230/1085/109/n504883639_8563.jpg\n:relationship_status: In a Relationship\n');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipients`
--

DROP TABLE IF EXISTS `recipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `recipients` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `alt_email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_recipients_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `recipients`
--

LOCK TABLES `recipients` WRITE;
/*!40000 ALTER TABLE `recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recordings`
--

DROP TABLE IF EXISTS `recordings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `recordings` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `filename` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `processing_error` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `command` varchar(255) default NULL,
  `command_expanded` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_recordings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `recordings`
--

LOCK TABLES `recordings` WRITE;
/*!40000 ALTER TABLE `recordings` DISABLE KEYS */;
/*!40000 ALTER TABLE `recordings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `regions` (
  `id` int(11) NOT NULL auto_increment,
  `country_id` int(11) NOT NULL,
  `group` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `abbreviation` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `guest_id` int(11) default NULL,
  `circle_id` int(11) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `name` varchar(255) default NULL,
  `end_at` datetime default NULL,
  `notes` text,
  `start_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_relationships_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `relationships`
--

LOCK TABLES `relationships` WRITE;
/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `authorizable_type` varchar(40) default NULL,
  `authorizable_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles_users` (
  `user_id` int(11) default NULL,
  `role_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  KEY `role_id` (`role_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) NOT NULL,
  `country_id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `degree` varchar(255) default NULL,
  `fields` varchar(255) default NULL,
  `start_at` date default NULL,
  `end_at` date default NULL,
  `activities_societies` varchar(255) default NULL,
  `awards` varchar(255) default NULL,
  `recognitions` varchar(255) default NULL,
  `notes` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_schools_on_profile_id` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `start_at` datetime default NULL,
  `end_at` datetime default NULL,
  `theme_id` int(11) NOT NULL default '0',
  `photo_file_name` varchar(255) default NULL,
  `photo_content_type` varchar(255) default NULL,
  `photo_file_size` int(11) default NULL,
  `photo_updated_at` datetime default NULL,
  `category_id` int(11) default NULL,
  `type` varchar(255) default NULL,
  `story` text,
  PRIMARY KEY  (`id`),
  KEY `index_stories_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_discounts`
--

DROP TABLE IF EXISTS `subscription_discounts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_discounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `amount` decimal(6,2) default '0.00',
  `percent` tinyint(1) default NULL,
  `start_on` date default NULL,
  `end_on` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_discounts`
--

LOCK TABLES `subscription_discounts` WRITE;
/*!40000 ALTER TABLE `subscription_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_payments`
--

DROP TABLE IF EXISTS `subscription_payments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) default NULL,
  `subscription_id` int(11) default NULL,
  `amount` decimal(10,2) default '0.00',
  `transaction_id` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `setup` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `account_id` (`account_id`),
  KEY `subscription_id` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_payments`
--

LOCK TABLES `subscription_payments` WRITE;
/*!40000 ALTER TABLE `subscription_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_plans`
--

DROP TABLE IF EXISTS `subscription_plans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscription_plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `amount` decimal(10,2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `setup_amount` decimal(10,2) default NULL,
  `trial_period` int(11) default '1',
  `allow_subdomain` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_plans`
--

LOCK TABLES `subscription_plans` WRITE;
/*!40000 ALTER TABLE `subscription_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `amount` decimal(10,2) default NULL,
  `next_renewal_at` datetime default NULL,
  `card_number` varchar(255) default NULL,
  `card_expiration` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `state` varchar(255) default 'trial',
  `subscription_plan_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `billing_id` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) NOT NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `themes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `themes`
--

LOCK TABLES `themes` WRITE;
/*!40000 ALTER TABLE `themes` DISABLE KEYS */;
/*!40000 ALTER TABLE `themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_locks`
--

DROP TABLE IF EXISTS `time_locks`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `time_locks` (
  `id` int(11) NOT NULL auto_increment,
  `lockable_id` int(11) default NULL,
  `lockable_type` varchar(255) default NULL,
  `unlock_on` date default NULL,
  `days_after` int(11) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_time_locks_on_lockable` (`lockable_id`,`lockable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `time_locks`
--

LOCK TABLES `time_locks` WRITE;
/*!40000 ALTER TABLE `time_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timelines`
--

DROP TABLE IF EXISTS `timelines`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timelines` (
  `id` int(11) NOT NULL auto_increment,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `timelines`
--

LOCK TABLES `timelines` WRITE;
/*!40000 ALTER TABLE `timelines` DISABLE KEYS */;
/*!40000 ALTER TABLE `timelines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcodings`
--

DROP TABLE IF EXISTS `transcodings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `transcodings` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) NOT NULL,
  `size` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `width` varchar(255) default NULL,
  `height` varchar(255) default NULL,
  `duration` varchar(255) default NULL,
  `video_codec` varchar(255) default NULL,
  `audio_codec` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `processing_error_message` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `bitrate` varchar(255) default NULL,
  `fps` varchar(255) default NULL,
  `command` varchar(255) default NULL,
  `command_expanded` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `transcodings`
--

LOCK TABLES `transcodings` WRITE;
/*!40000 ALTER TABLE `transcodings` DISABLE KEYS */;
/*!40000 ALTER TABLE `transcodings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `identity_url` varchar(255) default NULL,
  `state` varchar(255) NOT NULL default 'passive',
  `deleted_at` datetime default NULL,
  `invitation_id` int(11) default NULL,
  `invitation_limit` int(11) NOT NULL default '0',
  `type` varchar(255) default NULL,
  `account_id` int(11) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `password_salt` varchar(255) default NULL,
  `facebook_uid` bigint(20) default NULL,
  `last_request_at` datetime default NULL,
  `current_login_ip` varchar(255) default NULL,
  `current_login_at` datetime default NULL,
  `login_count` int(11) NOT NULL default '0',
  `persistence_token` varchar(255) NOT NULL,
  `last_login_ip` varchar(255) default NULL,
  `last_login_at` datetime default NULL,
  `email_hash` varchar(255) default NULL,
  `perishable_token` varchar(255) default NULL,
  `failed_login_count` int(11) NOT NULL default '0',
  `facebook_secret_key` varchar(255) default NULL,
  `facebook_session_key` varchar(255) default NULL,
  `always_sync_with_facebook` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `users_email_index` (`email`),
  KEY `users_facebook_uid_index` (`facebook_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'peter@fadelhintz.uk','peter@fadelhintz.uk','ed9e4a3c0a3b3bd1b78385c565ba0f9b7477d7f56dbb1aede8b00a9ff2f4b585cb29ffd25a1baa8c8f9ffed4dc5797f89b6d36f81ac13af6ce440e5f5a4e2a59','2009-07-13 05:27:32','2009-07-13 05:27:33','779369986875d525708a1816addc86c11e25fe38','2009-07-13 05:27:32',NULL,'live',NULL,NULL,5,'Member',NULL,'Adams','facebook','HubBwwmQCNFAqtWtTBV9',504883639,NULL,NULL,NULL,0,'774c61a982e1bfb59db134b6f00f1a8913241b068268b9d4477c8c73ad6a848344dfc9bd04529496ad7a39331674761938c64fc1db89d604c228040ec55f0c60',NULL,NULL,NULL,'rwq82qfYIggkMfdF5kst',0,'oMlcrlaGX_8C6b3_C9oXqw__','2.DPd4uDYC2w7fBrDtg3IRZA__.86400.1246140000-504883639',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-07-13  6:22:53
