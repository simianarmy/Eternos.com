-- MySQL dump 10.11
--
-- Host: localhost    Database: eternos_devel
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'Test Account','2009-07-16 18:10:59','2009-07-16 18:10:59','localhost',NULL,'joined'),(2,NULL,'2009-07-16 18:11:33','2009-07-16 18:11:34',NULL,NULL,'joined'),(3,NULL,'2009-07-27 17:09:37','2009-07-27 17:09:38',NULL,NULL,'joined'),(4,NULL,'2009-07-28 23:32:32','2009-07-28 23:32:32',NULL,NULL,'joined');
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
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `published_at` datetime default NULL,
  `guid` varchar(255) default NULL,
  `message` text,
  `attachment_data` text,
  `attachment_type` varchar(255) default NULL,
  `activity_type` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  `activity_stream_id` int(11) default NULL,
  `edited_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_activity_stream_items_on_activity_stream_id` (`activity_stream_id`)
) ENGINE=InnoDB AUTO_INCREMENT=298 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `activity_stream_items`
--

LOCK TABLES `activity_stream_items` WRITE;
/*!40000 ALTER TABLE `activity_stream_items` DISABLE KEYS */;
INSERT INTO `activity_stream_items` VALUES (1,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is cranking along on about four different projects, and all are going swimmingly... sleep calls!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(2,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'fascinated by this story...','--- \nhref: http://www.facebook.com/ext/share.php?sid=82878347698&amp;h=lx-KU&amp;u=EsgI9\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=efe120d59adafaf3decac07f2c0ae410&amp;url=http%3A%2F%2Facidcow.com%2Fcontent%2Fimg%2Fnew03%2F25%2F22.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(3,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'learning about the history of weed, thanks Showtime!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81970569404&amp;h=CqUBk&amp;u=znUr6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2686a5b094f8b59355897de6bad9f27c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FzfiaC-2K1LM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=81970569404#s81970569404\n  source_url: http://www.youtube.com/v/zfiaC-2K1LM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=zfiaC-2K1LM&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: History of Weed\n','video','post','FacebookActivityStreamItem',1,NULL),(4,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wonders why people put up with this police state bullshit.  OMG!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108514165791&amp;h=4VyLp&amp;u=5M5QB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d9240500226b1d1587b91b6027b7cfe9&amp;url=http%3A%2F%2Fwww.wired.com%2Fimages_blogs%2Fthreatlevel%2F2009%2F05%2Ffcc_badge.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(5,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is thinking about taking a long stroll at folklife and stuffing my face for as many hours as possible in the sun today :)',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(6,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just blocked ten people from his newsfeed for taking those obnoxious quizzes.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(7,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is in the midst of having a mindblowingly good weekend!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(8,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1810565&amp;id=504883639\nphoto: \n  pid: \"2168458717792280709\"\n  aid: \"2168458717790550922\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_83405843639_504883639_1810565_5659759_s.jpg\ntype: photo\nalt: IMG_1180\n','photo','post','FacebookActivityStreamItem',1,NULL),(9,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'A man with one watch knows what time it is; a man with two watches is never quite sure.  ~Lee Segall',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(10,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is watching this astounding mechanical Lego pirate theater, controlled by Mindstorm/Nextstorm robot Lego, marries the Victorian dramatic clockwork automaton with 21st century cheap computation and precision brick-making. And it\'s got pirates! Seriously, some people have WAAAAY too much time on their hands!','--- \nhref: http://www.facebook.com/ext/share.php?sid=106651591257&amp;h=kdY6S&amp;u=s5j3S\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=e4a2b0b9f01d04041cad03744009e5f6&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FIkDsre1ltvk%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=106651591257#s106651591257\n  source_url: http://www.youtube.com/v/IkDsre1ltvk&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=IkDsre1ltvk&amp;\n  owner: \"504883639\"\nalt: LEGO Mindstorms NXT, Pirates and the NXTfied Theater\n','video','post','FacebookActivityStreamItem',1,NULL),(11,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'it slices!  It dices!  This thing is bad ass!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81641852983&amp;h=n4lgk&amp;u=_GaYx\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a705865d808e7268740ddbbcd765c8d6&amp;url=http%3A%2F%2Fstatic.gamesbyemail.com%2FNews%2FDiceOMatic%2FCameraLights.jpg%3F633789125654312915&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(12,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'so not funny, it\'s funny.  Well, not really.  More just morbidly entertaining...','--- \nhref: http://www.facebook.com/ext/share.php?sid=179221960031&amp;h=B78ga&amp;u=vCExk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=40b122d8dd7a50addbf04cdd51ad440d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FA9QpOfhAPXs%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=179221960031#s179221960031\n  source_url: http://www.youtube.com/v/A9QpOfhAPXs&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=A9QpOfhAPXs&amp;eurl=http://www.cracked.com/blog/i-quit-comedy-the-best-video-of-all-time&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: I\'m on a Couch (The Lonely Island - &quot;I\'m on a Boat&quot; parody spoof)\n','video','post','FacebookActivityStreamItem',1,NULL),(13,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'watching a dude dialup to the Internet using a 1964 300 bps modem.  &lt;geek&gt;','--- \nhref: http://www.facebook.com/ext/share.php?sid=109788136258&amp;h=yWGGN&amp;u=eZd9P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0095242ec2c2bf10e68b1688ccf5a35f&amp;url=http%3A%2F%2Fgadgets.boingboing.net%2F2009%2F05%2F27%2Fstyle%2Fatboingboing.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(14,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'totally worth the watch... starts slow builds up to a hilarious result... two baseball teams tired of waiting five hours in a rain delay decide to have a dance off!  They are GOOD!','--- \nhref: http://www.facebook.com/ext/share.php?sid=99311083648&amp;h=Lhn3M&amp;u=hyjHN\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f501750d502ba518131ebeb2b385ec6a&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FaazG7dMhE7I%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=99311083648#s99311083648\n  source_url: http://www.youtube.com/v/aazG7dMhE7I&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=aazG7dMhE7I&amp;eurl=http://ourkitchensink.com/2009/05/27/the-greatest-moment-in-rain-delay-history/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Dance Off USF vs Uconn 2009 Big East Baseball Tournament as seen on PTI.\n','video','post','FacebookActivityStreamItem',1,NULL),(15,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'gives props to Eminem for returning to old form.  WOW.  His new album is *stunning*.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(16,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'decision time tonight.  at least my decision is easy!','--- \nhref: http://www.facebook.com/ext/share.php?sid=82828673175&amp;h=yX4sK&amp;u=atDk6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=668c5c66381d93ec70db2dd972a7ef08&amp;url=http%3A%2F%2Fflowingdata.com%2Fwp-content%2Fuploads%2F2009%2F01%2Fgoldstarman2-545x385.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(17,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'thinks birds are smart.','--- \nhref: http://www.facebook.com/ext/share.php?sid=105618949438&amp;h=n5fEv&amp;u=9Sg5-\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3f58aa412bc6316764a6c7eac424bb5d&amp;url=http%3A%2F%2Fwww.telegraph.co.uk%2Ftelegraph%2Fmultimedia%2Farchive%2F01111%2Fxelect60_1111910h.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(18,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'fun!  shot entirely with a still camera (wait till end to see making of)','--- \nhref: http://www.facebook.com/ext/share.php?sid=87034512396&amp;h=rRhGW&amp;u=3eYwl\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=4f7dd0eea4d34686376352078d4ec53c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FPgpRz3RHJMw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=87034512396#s87034512396\n  source_url: http://www.youtube.com/v/PgpRz3RHJMw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=PgpRz3RHJMw&amp;eurl=http://www.boingboing.net/2009/05/29/sorry-im-late-stop-m.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Sorry i\'m late\n','video','post','FacebookActivityStreamItem',1,NULL),(19,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'had an amazing day with his son, Lena, and Robin - teeball game, miniature golf, trampolines, and building a dam on the beach.  Holy &amp;!@# pure heaven in this weather!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(20,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nname: I farted in your face and then you stole my wallet\nhref: http://www.facebook.com/group.php?gid=81615419170\nfb_object_id: \"81615419170\"\nfb_object_type: group\nicon: http://static.ak.fbcdn.net/images/icons/group.gif?8:25796\nmedia: {}\n\ncaption: Common Interest - Activities\ndescription: Has this happened to you?\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,NULL),(21,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843134&amp;id=504883639\nphoto: \n  pid: \"2168458717792313278\"\n  aid: \"2168458717790552260\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679763639_504883639_1843134_4182462_s.jpg\ntype: photo\nalt: IMG_1187\n','photo','post','FacebookActivityStreamItem',1,NULL),(22,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843146&amp;id=504883639\nphoto: \n  pid: \"2168458717792313290\"\n  aid: \"2168458717790552261\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680338639_504883639_1843146_7216025_s.jpg\ntype: photo\nalt: IMG_1200\n','photo','post','FacebookActivityStreamItem',1,NULL),(23,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'The Coolest House in the Neighborhood (And Maybe the Galaxy)','--- \nhref: http://www.facebook.com/ext/share.php?sid=180076720315&amp;h=GlJnM&amp;u=rs_SR\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d06b5a211c3893aeca0b1a8a670e6c22&amp;url=http%3A%2F%2Fcdn-i.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17435%2Ffuturehouse_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(24,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Dear Media, I\'ve had enough hearing about Susan Boyle.  KKTHXBAI.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(25,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'won a poker tournament last night.  What a rush!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(26,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is melting from the heat',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(27,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'totally sacked out for a nap in 85 degree heat with a modicum of clothing on... for three hours... ouch....',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(28,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is starting to think evil thoughts...','--- \nhref: http://www.facebook.com/ext/share.php?sid=101500368271&amp;h=TU3MC&amp;u=DK_Hs\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a6483ba371ea7faa040fca781bc7463d&amp;url=http%3A%2F%2Fhowto.wired.com%2Fmediawiki%2Fimages%2FSt_howto_explodingdrink.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(29,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'finally understands the biblical meaning of &quot;Marriage&quot;','--- \nhref: http://www.facebook.com/ext/share.php?sid=105295259883&amp;h=4AOfZ&amp;u=LFkY6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47f44c7b17752fe0548a5ba0d688b4bb&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FOFkeKKszXTw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=105295259883#s105295259883\n  source_url: http://www.youtube.com/v/OFkeKKszXTw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=OFkeKKszXTw\n  owner: \"504883639\"\nalt: Betty Bowers Explains Traditional Marriage to Everyone Else\n','video','post','FacebookActivityStreamItem',1,NULL),(30,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'really, really can\'t stand conan o\'brien.  I\'ve tried.  Three times this week.  To laugh even a little at his tired old schtick.  Sometimes, I laugh during the commercials, but never during the program.  Bed time is at 11:30 for me now apparently :(',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(31,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is having a great day with his son!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(32,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Give me my iPhone 3G 3.0 OS!  I\'ll pass on the hardware upgrade for this generation tho.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(33,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'finally an upgrade to my ][GS, I now can get a THREE-GS!  Sweet thanks apple!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(34,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just hid three more friends for taking these totally inane quizzes with artificially random results that just do nothing but clog up my newsfeed.  Die facebook quizzes. Die.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(35,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wants you to check out the new website I did for my girlfriend and let me know what you think.  See if you can find the dirty pics!','--- \nhref: http://www.facebook.com/ext/share.php?sid=103480538944&amp;h=C7yFJ&amp;u=wde24\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a10de2e5a4bf01d31726c7e2610d8f77&amp;url=http%3A%2F%2Fwww.fairmontolympicweddings.com%2Fwp-content%2Fthemes%2Ffairmont%2Fimages%2Fcontent.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(36,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'feels GREAT!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108019026344&amp;h=tM7Jg&amp;u=semhb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=df9126c53ac6412f984931658a88de8c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJC2gIPnUCgw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=108019026344#s108019026344\n  source_url: http://www.youtube.com/v/JC2gIPnUCgw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=JC2gIPnUCgw\n  owner: \"504883639\"\nalt: nutrigrain commercial\n','video','post','FacebookActivityStreamItem',1,NULL),(37,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is enjoying the nice WARM weather.  Not hot.  Not cold.  Just RIGHT.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(38,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'has opened Eternos.com for Beta registration.  Please go register your email address to get notified soon as we open for beta!','--- \nhref: http://www.facebook.com/ext/share.php?sid=218902860009&amp;h=ftCC5&amp;u=hs2qW\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=bda5b9c79c7f2f28885c578aef99666a&amp;url=http%3A%2F%2Fwww.eternos.com%2Fimages%2Fbeta.gif%3F1244663389&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(39,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'this is why I hate the government.  And some people want them to run health care??  $9 TRILLION dollars in off-balance sheet transactions, and no monitoring system in place for public review?  It really is no joke this country has been sold off in pieces and we all better start learning Chinese.  And I\'m not exaggerating or overreacting.  It\'s pretty sad.','--- \nhref: http://www.facebook.com/ext/share.php?sid=115462236627&amp;h=RUPFY&amp;u=EZhjM\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a94b39c20594b199be1dce1dbbf2ee52&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FcJqM2tFOxLQ%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=115462236627#s115462236627\n  source_url: http://www.youtube.com/v/cJqM2tFOxLQ&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=cJqM2tFOxLQ&amp;eurl=http://dailybail.com/home/there-are-no-words-to-describe-the-following-part-ii.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"High Quality Version: Is Anyone Minding the Store at the Federal Reserve?\"\n','video','post','FacebookActivityStreamItem',1,NULL),(40,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'for some reason it feels like Friday to me today.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(41,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'pretty much has the best girlfriend ever!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(42,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'anyone want to watch my adorable Pug, Borf, for 10 days starting July 1st while I\'m in Hawaii?  Pleeeeaseeee',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(43,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is in love with the best of the best!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(44,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is now known as http://www.facebook.com/nerolabs  Vanity username for the win!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(45,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is looking at a NATURAL tree fall in West Seattle.  AWESOME!','--- \nhref: http://www.facebook.com/ext/share.php?sid=89287909614&amp;h=gCBLX&amp;u=pSsbK\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7fae08aa639d8494b14ae42f3ee74c29&amp;url=http%3A%2F%2Fwestseattleblog.com%2Fblog%2Fwp-content%2Fuploads%2F2009%2F06%2Fzzmonster.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(46,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Hours of Operation','--- \nhref: http://www.facebook.com/ext/share.php?sid=95673251446&amp;h=IoOd6&amp;u=lHqBi\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=16e0d51c53a84c99b2d8089350decb2f&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3080%2F3152352551_706d9ca6a1_o.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(47,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Sunday is cleaning and bills paying night and getting ready for the next week!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(48,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Gratz to the Lakers.  Kobe, on the other hand, can suck me.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(49,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'~32,000 American Scientists Agree:  Global Warming is BULLSHIT','--- \nhref: http://www.facebook.com/ext/share.php?sid=190996770074&amp;h=GHGJU&amp;u=8Lymb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c635339fa7f617c17b6dc569080115b1&amp;url=http%3A%2F%2Fwww.campaignforliberty.com%2Fimg%2Fauthor%2Fpaul.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(50,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1917001&amp;id=504883639\nphoto: \n  pid: \"2168458717792387145\"\n  aid: \"2168458717790555233\"\n  index: \"3\"\n  height: \"403\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/s504883639_1917001_8036523.jpg\ntype: photo\nalt: 004_4\n','photo','post','FacebookActivityStreamItem',1,NULL),(51,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wants to be a cat','--- \nhref: http://www.facebook.com/ext/share.php?sid=92502495980&amp;h=IYv8n&amp;u=_jEbo\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f73c0c2216fc5c560994fb53943610c9&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJ5Xrcp6k8VE%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=92502495980#s92502495980\n  source_url: http://www.youtube.com/v/J5Xrcp6k8VE&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=J5Xrcp6k8VE&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: How catnip gets cats high\n','video','post','FacebookActivityStreamItem',1,NULL),(52,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'thinks Obama is a wolf in sheeps clothing.','--- \nhref: http://www.facebook.com/ext/share.php?sid=91375379508&amp;h=GoMo9&amp;u=RI7y_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=92fae83da333a7ba2d2fb7f127d2a417&amp;url=http%3A%2F%2Fmsnbcmedia.msn.com%2Fj%2FMSNBC%2FComponents%2FBylines%2Fmugs%2FMSNBC%2520Interactive%2Fbill_dedman_2.thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(53,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'if you protest the government in any way, you are a terrorist: straight from the Department of Defense','--- \nhref: http://www.facebook.com/ext/share.php?sid=94299282445&amp;h=2C38f&amp;u=jhdhv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=90b8c2b48180923b4cf51402c2dd7569&amp;url=http%3A%2F%2Fwww.infowars.net%2Fpictures%2Fjune2009%2F150609protest.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(54,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'updated his theme on his blog... check it out','--- \nhref: http://www.facebook.com/ext/share.php?sid=119626995927&amp;h=6_FZ-&amp;u=rrCEL\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b8ee8cb1c8c76b92a89dd4b0de6875d6&amp;url=http%3A%2F%2Fedmondfamily.com%2Fgallery2%2Fmain.php%3Fg2_view%3Dcore.DownloadItem%26g2_itemId%3D3496%26g2_serialNumber%3D2&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(55,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wonders what &quot;...according to scientists, is that winter temperatures across the Great Plains and Midwest are now some 7Âº warmer than historical norms&quot;.  According to my understanding of the climate, there is NO SUCH THING as a &quot;Historical Norm&quot; when it comes to weather :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=107975996440&amp;h=KPs3X&amp;u=hZDR4\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=756995be59d1549c05817c9ccee0e8e7&amp;url=http%3A%2F%2Fwww.scientificamerican.com%2Fmedia%2Finline%2F000BA112-8AB6-1E83-85F7809EC588EEDF_1_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(56,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is looking forward to FATHERS DAY!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(57,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'reading that Pixar sent an employee with a DVD of \'Up\' to a dying girl as a last wish.  One of the most touching stories I\'ve read in a while... get the tissue out...','--- \nhref: http://www.facebook.com/ext/share.php?sid=99373067465&amp;h=49aMl&amp;u=u_-xX\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=05f012078c4310aaa57bdd0cbc8ee6b8&amp;url=http%3A%2F%2Fimages.ocregister.com%2Fnewsimages%2Fcommunity%2Fhuntingtonbeach%2F2009%2F04%2Fcolby_med.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(58,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'pretty good tilt-shift + time-lapse video!  Love it!','--- \nhref: http://www.facebook.com/ext/share.php?sid=111180392194&amp;h=LJT_t&amp;u=xnhmY\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b1f09016b22c47e4e3362277947ca1f5&amp;url=http%3A%2F%2Fts.vimeo.com.s3.amazonaws.com%2F155%2F790%2F15579090_160.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=111180392194#s111180392194\n  source_url: http://vimeo.com/moogaloop.swf?clip_id=5137183\n  source_type: html\n  display_url: http://vimeo.com/5137183\n  owner: \"504883639\"\nalt: Bathtub V\n','video','post','FacebookActivityStreamItem',1,NULL),(59,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just took my dog to the vet.  Stiff muscles and pinched nerve.  Some doggie aspirin and $72 makes it the cheapest vet visit ever!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(60,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'does not get his son on Fathers Day, due to his ex being... well... it\'s not polite to say.  GRRRRR',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(61,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Twitter Kills','--- \nhref: http://www.facebook.com/ext/share.php?sid=194616800023&amp;h=Ac9Ve&amp;u=lLmXk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=884f002049d26adf85337b9e315cb5ab&amp;url=http%3A%2F%2Fwww.austriantimes.at%2Fthumbnails%2F6vkkfvy7_tiny.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(62,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is going on 14 days without seeing or even talking to his son.  Aggressive attorney hired, but legal stuff takes time.  This SUCKS.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(63,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'can this be for real?','--- \nhref: http://www.facebook.com/ext/share.php?sid=118330124011&amp;h=gyt0C&amp;u=wG45e\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=66ba91afb2c76e8b3e9c596c7dab0268&amp;url=http%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fa%2Fa4%2FAmphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg%2F240px-Amphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(64,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'thanks everyone for the wonderful birthday and fathers day wishes.  Keep praying that my lawyer gets my son to our family trip in Hawaii and prevents this type of abuse from happening again.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(65,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952825&amp;id=504883639\nphoto: \n  pid: \"2168458717792422969\"\n  aid: \"2168458717790556509\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/s504883639_1952825_4167047.jpg\ntype: photo\nalt: IMG_1214\n','photo','post','FacebookActivityStreamItem',1,NULL),(66,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952869&amp;id=504883639\nphoto: \n  pid: \"2168458717792423013\"\n  aid: \"2168458717790556513\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"401\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156648639_504883639_1952869_6072646_s.jpg\ntype: photo\nalt: Picture 007\n','photo','post','FacebookActivityStreamItem',1,NULL),(67,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'pretty clever','--- \nhref: http://www.facebook.com/ext/share.php?sid=100941976217&amp;h=7Jk8r&amp;u=CfJh_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c83bc162dd40d88c02650232aafcf279&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F3eooXNd0heM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=100941976217#s100941976217\n  source_url: http://www.youtube.com/v/3eooXNd0heM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=3eooXNd0heM&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"Auto-Tune the News #5: lettuce regulation. American blessings.\"\n','video','post','FacebookActivityStreamItem',1,NULL),(68,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'more proof that if you tell someone something is &quot;green&quot; that they automatically turn their brains off, or maybe it\'s because the green movement allows for zero skepticism without chastisment.  Sounds like the green movement is taking a cue from the right wing zealots that use peer pressure to sell their beliefs, which more often than not are completely erroneous.','--- \nname: US shoppers misled by greenwash, Congress told | Environment | guardian.co.uk\nhref: http://www.facebook.com/ext/share.php?sid=100787792815&amp;h=MoEzB&amp;u=grkH8\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.guardian.co.uk\"\ndescription: 98% of supposedly environmentally friendly products make potentially false or misleading claims, US campaigners say\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,NULL),(69,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is looking for people willing to write a Declaration to the court regarding my most awesome Dadness to Jack, as well as can state their opinion regarding Natalie\'s continued assault on me.  Email me at andrew@andrewedmond.com or call me.  I really need as many people as I can that the court will consider credible witnesses.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(70,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is celebrating my birthday AND Robin and I\'s six month anniversary tonight!!  Prayers for Jack welcomed from All!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(71,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just got the hottest, most thoughtful, amazing, kick ass, unbelievable, intense, beautiful, sexy, thoroughly overwhelming birthday present ever from Robin! What a babe!!!!!!!!!!!!!!!!!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(72,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'watching a kid FREAK out when his mom cancels his World of Warcraft account.... right as he hits level 80.','--- \nhref: http://www.facebook.com/ext/share.php?sid=120346397177&amp;h=-nksS&amp;u=pdkIJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=8d954d8254903b7e1348821170b5acba&amp;url=http%3A%2F%2F1.media.collegehumor.com%2Fcollegehumor%2Fch6%2F4%2F4%2Fcollegehumor.4a91d1f46db7c43b1aadf864ab8eed36.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=120346397177#s120346397177\n  source_url: http://www.collegehumor.com/moogaloop/moogaloop.swf?clip_id=1915521&amp;autostart=true\n  source_type: html\n  display_url: http://www.collegehumor.com/video:1915521\n  owner: \"504883639\"\nalt: WoW Freakout\n','video','post','FacebookActivityStreamItem',1,NULL),(73,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'what an amazing pic!','--- \nhref: http://www.facebook.com/ext/share.php?sid=95087931475&amp;h=PeyhX&amp;u=FtH1t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d33c44e424c9867ffbf9abd89835bb9a&amp;url=http%3A%2F%2Fmsnbcmedia3.msn.com%2Fj%2FMSNBC%2FComponents%2FPhoto%2F_new%2F090622-volcano-hmed2p.hmedium.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(74,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'go go Ron Paul!','--- \nhref: http://www.facebook.com/ext/share.php?sid=112448291083&amp;h=KG3ns&amp;u=qJ-5i\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ac701822824039bb6f753289ae42b930&amp;url=http%3A%2F%2Fwww.lewrockwell.com%2Fpaul%2FGoldPeaceProsperity_T.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(75,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'the truth about family holidays, at last','--- \nname: www.theonion.com\nhref: http://www.facebook.com/ext/share.php?sid=115495881353&amp;h=K1Pxq&amp;u=H8Ftj\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,NULL),(76,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Picture 1','--- \nhref: http://www.facebook.com/photo.php?pid=1960357&amp;id=504883639\nphoto: \n  pid: \"2168458717792430501\"\n  aid: \"2168458717790556751\"\n  index: \"1\"\n  height: \"348\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93624863639_504883639_1960357_4561644_s.jpg\ntype: photo\nalt: Picture 1\n','photo','post','FacebookActivityStreamItem',1,NULL),(77,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'pyramids in the USA.  Also for no discernible purpose.  Huh, who knew?','--- \nhref: http://www.facebook.com/ext/share.php?sid=100881712186&amp;h=pfZPj&amp;u=prfle\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=58c5f969b2219dcccf9b2092d016ae88&amp;url=http%3A%2F%2Fwww.boingboing.net%2F000418l3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(78,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'and we think Iran is effed up?  Really?','--- \nhref: http://www.facebook.com/ext/share.php?sid=107187719051&amp;h=-4SEX&amp;u=VyDWD\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0537f3dd7048cd052f58cb962d057fe6&amp;url=http%3A%2F%2Fi.cdn.turner.com%2Fcnn%2F2009%2FPOLITICS%2F06%2F23%2FUS.syria.ambassador%2Ftzmos.mitchell.assad.gi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(79,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is determined.  Focused.  Wait, what was I saying?',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(80,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'a statement about our post-industrial world.  Sublime.','--- \nhref: http://www.facebook.com/ext/share.php?sid=208344885695&amp;h=D8cUH&amp;u=FGR4V\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=fcb3a8a988ac8536644514b3cf561972&amp;url=http%3A%2F%2Fcraphound.com%2Fimages%2Fgoldi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(81,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'get a haircut, please, PLEASE!','--- \nhref: http://www.facebook.com/ext/share.php?sid=107888324048&amp;h=8XTCx&amp;u=Q-Xok\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2a1e086a9955997b1b71c4cec3e2a61c&amp;url=http%3A%2F%2Finlinethumb05.webshots.com%2F26564%2F2444545680105101600S600x600Q85.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(82,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'thanks everyone that has pitched in with help for re-establishing EQUAL custody with my son.  Fatherhood is NOT a privilege granted by Moms... but a RIGHT, even though sometimes we have to fight for it.  Soon... soon....',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(83,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'finds it funny that the Toyota Prius takes three times more energy to produce than a Hummer, totally offsetting any conceived &quot;savings&quot; to the environment...','--- \nhref: http://www.facebook.com/ext/share.php?sid=112449587867&amp;h=aIAGQ&amp;u=axm5j\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b750bd4b494a647bab291644d6f3bfee&amp;url=http%3A%2F%2Fclubs.ccsu.edu%2Frecorder%2F%2Fmain%2Fccsulogo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(84,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'more environmental shenanigans.  I really wish the green movement had more built in skepticism, but anything goes I supposed!','--- \nhref: http://www.facebook.com/ext/share.php?sid=123982352904&amp;h=utKVR&amp;u=K5J4p\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=974272c296c509112efc3f9cf8377427&amp;url=http%3A%2F%2Fcache.consumerist.com%2Fassets%2Fimages%2F31%2F2009%2F06%2Fpeanut1.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(85,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'a green movement that helps people save money, educate themselves, and is based on real, factual data... this is something I can support!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108698398616&amp;h=3N6pR&amp;u=MM6IJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d8d3cf855dbbdc55463f07b3b5f5b48f&amp;url=http%3A%2F%2Fimages.google.com%2Furl%3Fsource%3Dimgres%26ct%3Dtbn%26q%3Dhttp%3A%2F%2Fblog.infotrends.com%2Fwordpress%2Fwp-content%2Fgallery%2Fgreen-logo%2Fmicrosoft-green_hp.jpg%26usg%3DAFQjCNHJSO4LP0DEMUx9eWR3VY5gMixarQ&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(86,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'fascinating','--- \nhref: http://www.facebook.com/ext/share.php?sid=113961277027&amp;h=yam5X&amp;u=TAurF\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6190c165eb4071ae3bef699460ee0882&amp;url=http%3A%2F%2Fwww.dailymotion.com%2Fthumbnail%2F160x120%2Fvideo%2Fx4muob_zoom-into-a-tooth_tech&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=113961277027#s113961277027\n  source_url: http://www.dailymotion.com/swf/x4muob?autoPlay=1\n  source_type: html\n  display_url: http://www.dailymotion.com/video/x4muob_zoom-into-a-tooth_tech\n  owner: \"504883639\"\nalt: Dailymotion - Zoom into a Tooth - a Tech &amp; Science video\n','video','post','FacebookActivityStreamItem',1,NULL),(87,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Suze Orman tells me a &quot;budget&quot; is like a &quot;diet&quot; for money.  I feel enlightened.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(88,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'funny as hell','--- \nhref: http://www.facebook.com/ext/share.php?sid=94755871589&amp;h=Tl2hj&amp;u=mJI1n\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47ed67f229dfe2caec6c5e7ee58a1ccc&amp;url=http%3A%2F%2Ftrueslant.com%2Frachelking%2Ffiles%2F2009%2F06%2F300px-virgin_america_a320_cabin.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(89,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'So John McCain thinks the president should have responded more harshly to the situation in Iran.  However, from this article: &quot;at the Republican National Committee convention in St. Paul in 2004,  250 protesters were arrested shortly before John McCain took the podium. Most were innocent activists and even journalists.&quot;  What a hypocrite.','--- \nname: \"Informed Comment: Washington and the Iran Protests:\"\nhref: http://www.facebook.com/ext/share.php?sid=94997638190&amp;h=ZKuZX&amp;u=Q-QYw\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.juancole.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,NULL),(90,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'they need to teach a class in facebook etiquette',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(91,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wow, this is a REAL advertisement for IE8???  WOWOWOWOWO','--- \nhref: http://www.facebook.com/ext/share.php?sid=95526323542&amp;h=wEa1o&amp;u=oYcUG\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3379b4a491cbb4732a88173f1e5ca83d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F8-9Mjm-Hohc%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=95526323542#s95526323542\n  source_url: http://www.youtube.com/v/8-9Mjm-Hohc&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=8-9Mjm-Hohc&amp;eurl=http://gizmodo.com/5302248/dean-cain-wards-off-puke-and-porn-with-internet-explorer-8-nsfl&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: O.M.G.I.G.P. - Internet Explorer 8\n','video','post','FacebookActivityStreamItem',1,NULL),(92,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'wants a Cabybara.  Winner to get the first reference to this rodents name (Caplin Rous)','--- \nhref: http://www.facebook.com/ext/share.php?sid=101192687115&amp;h=uRE9J&amp;u=kqO3K\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7471338a4ffea137061bef8544be0028&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3618%2F3658068677_52d3857f02.jpg%3Fv%3D0&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(93,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'RIP Farrah Fawcet',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(94,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Ed Macmahon... Farrah Fawcet... Patrik Swayze next?',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(95,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'http://www.tmz.com/2009/06/25/michael-jackson-dies-death-dead-cardiac-arrest/','--- \nhref: http://www.facebook.com/ext/share.php?sid=97219678547&amp;h=E5Abt&amp;u=Yio4N\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d98fc22bca4166f2d2ff9d12eccc7a97&amp;url=http%3A%2F%2Fwww.blogcdn.com%2Fwww.tmz.com%2Fmedia%2F2009%2F06%2F0625_michael_jackson_ex2.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(96,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'TMZ typically breaks news in advance because they have people on every LA area hospital.  More reputable organizations do not engage in those type of practices.  Despite the ethics, I am 99% sure TMZ is right here, and people at CNN and FOX should at LEAST report that TMZ is reporting rather than BLATANTLY ignoring that report.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(97,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'LA TIMES CONFIRMS MJ IS DEAD','--- \nhref: http://www.facebook.com/ext/share.php?sid=108375399592&amp;h=6FZlx&amp;u=8k_0P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=04659cdefc877c7febbce3f425ff959c&amp;url=http%3A%2F%2Flatimesblogs.latimes.com%2Flanow%2Fktla-logo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(98,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'OMG.  Jeff Goldblum is NOT dead.  Knock it off.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(99,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'neat stuff here *thanks sean*','--- \nhref: http://www.facebook.com/ext/share.php?sid=95716179033&amp;h=VRnq_&amp;u=m7d15\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=340bf8dd95f6f5f814cb8ee0e2012458&amp;url=http%3A%2F%2Fwww.webdesignerdepot.com%2Fwp-content%2Fuploads%2Fphoto_manipulation%2Fphoto_manipulation.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(100,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'think you gotta know me pretty well to understand this one','--- \nhref: http://www.facebook.com/ext/share.php?sid=97434442218&amp;h=II1iR&amp;u=8Xt45\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=738662a89784f4fdb4418ce8bdaae1d0&amp;url=http%3A%2F%2Fi.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17531%2Fjloh_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(101,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Good Stuff!','--- \nhref: http://www.facebook.com/ext/share.php?sid=92521878203&amp;h=WS4Cy&amp;u=4xyOv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=db3c2fc87743b6d992afe575e75b2230&amp;url=http%3A%2F%2Fwww.dailygalaxy.com%2F.a%2F6a00d8341bf7f753ef011571591c67970b-500wi&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(102,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just got out of court.  I won and Jack is going to HAWAII with us in six days!  Thanks everyone for their support!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(103,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just finished the [Frostbitten] achievement!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(104,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'ouch  ouch   ouch  my head  ouch',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(105,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'oh.. the irony...','--- \nhref: http://www.facebook.com/ext/share.php?sid=95666789393&amp;h=0zkuq&amp;u=jHsHt\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ea8a6ede06cbc087a42220dab7647307&amp;url=http%3A%2F%2Fwww.sfscope.com%2F2009%2F05%2Funthinkable3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(106,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'preparing for Hawaii is stressful!  Getting to Hawaii will be peaceful!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(107,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'okay guys, I hate to say it... Carradine, Fawcet, McMahon, Jackson, Mays... we are in the midst of a major celebrity pruning...  I am voting for Swayze next... who else do you think is going to kick the bucket?  Vote now!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(108,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'this was an AMAZING Rolling Stone Article about Goldman Sachs, not available online until this guy put it online.  What a read.  Amazing, MUST read story!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=96830267916&amp;h=9vJPR&amp;u=Dv7Mh\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c989b8093c9356aa494848c030f4d4cc&amp;url=http%3A%2F%2Ffi.somethingawful.com%2Fcustomtitles%2Ftitle-paper_mac.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(109,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just heard a good one... &quot;Billy Mays heard that celebrities die in threes... leave it up to him to throw in an extra for free!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(110,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'skepticism is a good thing :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=109998674416&amp;h=fpYxP&amp;u=UhTuB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6c0f9134ad5b251f4bab2595864e8836&amp;url=http%3A%2F%2Fwww.quarrygirl.com%2Fwp-content%2Fuploads%2F2009%2F06%2Flotus-vegan-tests-570x214.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(111,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'I\'ll take two','--- \nhref: http://www.facebook.com/ext/share.php?sid=135338090048&amp;h=gTW7A&amp;u=G7y4t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b4f49c2a5dca9c39a46d3f473150d8a&amp;url=http%3A%2F%2Fwww.blogsmithcdn.com%2Favatar%2Fimages%2F8%2F2706050_64.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(112,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'where we are staying in Maui, plane leaves in 48 hours!','--- \nhref: http://www.facebook.com/ext/share.php?sid=97812617481&amp;h=me28P&amp;u=cyYJ6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ab692551e934f6ec09b7dde55a258de0&amp;url=http%3A%2F%2Fwww.vacationrentalagent.com%2Fimages%2Frentals%2Fp2648_i9_1138229661.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(113,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is leaving on a jet plane...',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(114,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'on the ferry to go pick up my son for our trip to hawaii. I haven\'t seen him in 24 days, I\'m shaking with excitement!!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(115,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'does anyone else have a problem in the case that you advance pay for a service (cell phone minutes, gift cards, transportaion like ferry tickets) and they \'expire\' in 90 days with no possible refund?  How can something digital \'expire\'?  Theivery more like it.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(116,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'yep.  the last will of Michael Jackson, scanned in entirety','--- \nhref: http://www.facebook.com/ext/share.php?sid=130220558664&amp;h=97Euj&amp;u=IYsYS\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b5de2be5d3e47de2092b8240eb8bfa3&amp;url=http%3A%2F%2Fimg.docstoc.com%2Fthumb%2F100%2F8016703.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(117,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'this is what I plan to do in Hawaii..','--- \nhref: http://www.facebook.com/ext/share.php?sid=98896998621&amp;h=73l62&amp;u=U6W3T\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f190d45c088f8c836091b2c5abdd7ad6&amp;url=http%3A%2F%2Fmarkmathews.files.wordpress.com%2F2009%2F06%2Fdsc_9802.jpg%3Fw%3D500%26h%3D333&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(118,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'very inspiring...  (mr. jobs has been my hero since I was 11 years old)','--- \nhref: http://www.facebook.com/ext/share.php?sid=94776700767&amp;h=W8bvv&amp;u=GNsr7\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=5da65e9dc881c8fc6152dc531d6b468d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FD1R-jKKp3NA%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=94776700767#s94776700767\n  source_url: http://www.youtube.com/v/D1R-jKKp3NA&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=D1R-jKKp3NA\n  owner: \"504883639\"\nalt: Steve Jobs Stanford Commencement Speech 2005\n','video','post','FacebookActivityStreamItem',1,NULL),(119,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is heading to Hawaii with the kids at 2:40 today!!  Packed and ready to go.  I really dislike flying!!!  Robin heads out a day later and is flying first class sans kiddos, lucky her!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(120,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'what is better than seeing both your kids sit up bolt upright in bed and in unison say &quot;HAWAII!!  LETS GO SWIMMING!!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(121,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2016963&amp;id=504883639\nphoto: \n  pid: \"2168458717792487107\"\n  aid: \"2168458717790500067\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97226283639_504883639_2016963_17468_s.jpg\ntype: photo\nalt: {}\n\n','photo','post','FacebookActivityStreamItem',1,NULL),(122,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2023666&amp;id=504883639\nphoto: \n  pid: \"2168458717792493810\"\n  aid: \"2168458717790559128\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659613639_504883639_2023666_3645362_s.jpg\ntype: photo\nalt: IMG_1246\n','photo','post','FacebookActivityStreamItem',1,NULL),(123,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045780&amp;id=504883639\nphoto: \n  pid: \"2168458717792515924\"\n  aid: \"2168458717790559781\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712603639_504883639_2045780_6002293_s.jpg\ntype: photo\nalt: IMG_1284\n','photo','post','FacebookActivityStreamItem',1,NULL),(124,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045797&amp;id=504883639\nphoto: \n  pid: \"2168458717792515941\"\n  aid: \"2168458717790559782\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2045797_3936659.jpg\ntype: photo\nalt: IMG_1324\n','photo','post','FacebookActivityStreamItem',1,NULL),(125,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045818&amp;id=504883639\nphoto: \n  pid: \"2168458717792515962\"\n  aid: \"2168458717790559785\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714653639_504883639_2045818_2842033_s.jpg\ntype: photo\nalt: IMG_2305\n','photo','post','FacebookActivityStreamItem',1,NULL),(126,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047298&amp;id=504883639\nphoto: \n  pid: \"2168458717792517442\"\n  aid: \"2168458717790559838\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835568639_504883639_2047298_5035742_s.jpg\ntype: photo\nalt: IMG_1341\n','photo','post','FacebookActivityStreamItem',1,NULL),(127,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047415&amp;id=504883639\nphoto: \n  pid: \"2168458717792517559\"\n  aid: \"2168458717790559844\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2047415_6779141.jpg\ntype: photo\nalt: IMG_2359\n','photo','post','FacebookActivityStreamItem',1,NULL),(128,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'can\'t even begin to describe the love and affection for my fam, my new one with Jack and Lena and Robin, and my old one with Trev, Keenan, Ryan and Mima!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(129,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2051914&amp;id=504883639\nphoto: \n  pid: \"2168458717792522058\"\n  aid: \"2168458717790560009\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164403639_504883639_2051914_3841018_s.jpg\ntype: photo\nalt: IMG_2429\n','photo','post','FacebookActivityStreamItem',1,NULL),(130,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'just dropped off Robin and Lena at the airport... one more day in Maui then back to ... reality, oh noes!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(131,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'is dreading his flight home.  When are scientists going to invent a matter transportation / teleportation device.  I\'d pay double.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(132,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2057974&amp;id=504883639\nphoto: \n  pid: \"2168458717792528118\"\n  aid: \"2168458717790560214\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591663639_504883639_2057974_4968127_s.jpg\ntype: photo\nalt: IMG_1386\n','photo','post','FacebookActivityStreamItem',1,NULL),(133,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2058002&amp;id=504883639\nphoto: \n  pid: \"2168458717792528146\"\n  aid: \"2168458717790560215\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592463639_504883639_2058002_1414467_s.jpg\ntype: photo\nalt: IMG_2479\n','photo','post','FacebookActivityStreamItem',1,NULL),(134,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Last day in Hawaii and looking very very tan :)','--- \nhref: http://www.facebook.com/photo.php?pid=2058068&amp;id=504883639\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593833639_504883639_2058068_5149723_s.jpg\ntype: link\n','link','post','FacebookActivityStreamItem',1,NULL),(135,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'ouch. Back in Seattle on a redeye I didn\'t sleep on. Jet lag will suck for a couple days. Today especially. I\'ll be around but napping till hopefully I get fully adjusted tomorrow. Got to see my girls this morning and that is great!!!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(136,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'rested, still a little jet lagged, trying to catch up, plan to be putting in 14 hour days till I\'m back on pace.',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(137,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'OMG ROFLMOA!','--- \nname: Morgan Spurlock\'s Experiment To Try Heroin For 30 Days Enters 200th Day | The Onion - America\'s Fine\nhref: http://www.facebook.com/ext/share.php?sid=96378168341&amp;h=oGqAq&amp;u=lAx8b\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/news.gif?8:25796\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\ndescription: files/radionews/06-192 Morgan Spurlock _F.mp3\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,NULL),(138,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'West Seattle Street Fair and 85 degrees.  Good times!',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(139,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2070133&amp;id=504883639\nphoto: \n  pid: \"2168458717792540277\"\n  aid: \"2168458717790560616\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_100385838639_504883639_2070133_4101049_s.jpg\ntype: photo\nalt: IMG_0496\n','photo','post','FacebookActivityStreamItem',1,NULL),(140,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'Home plate seats!!','--- \nhref: http://www.facebook.com/photo.php?pid=2075720&amp;id=504883639\nphoto: \n  pid: \"2168458717792545864\"\n  aid: \"2168458717790500067\"\n  index: \"1\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_100641573639_504883639_2075720_8038526_s.jpg\ntype: photo\nalt: Home plate seats!!\n','photo','post','FacebookActivityStreamItem',1,NULL),(141,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,'sneezing',NULL,NULL,'status','FacebookActivityStreamItem',1,NULL),(142,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-20 06:31:49',NULL,'is cranking along on about four different projects, and all are going swimmingly... sleep calls!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-20 06:31:49'),(143,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-20 15:54:09',NULL,'fascinated by this story...','--- \nhref: http://www.facebook.com/ext/share.php?sid=82878347698&amp;h=lx-KU&amp;u=EsgI9\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=efe120d59adafaf3decac07f2c0ae410&amp;url=http%3A%2F%2Facidcow.com%2Fcontent%2Fimg%2Fnew03%2F25%2F22.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-20 15:54:09'),(144,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-21 19:09:21',NULL,'learning about the history of weed, thanks Showtime!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81970569404&amp;h=CqUBk&amp;u=znUr6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2686a5b094f8b59355897de6bad9f27c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FzfiaC-2K1LM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=81970569404#s81970569404\n  source_url: http://www.youtube.com/v/zfiaC-2K1LM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=zfiaC-2K1LM&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: History of Weed\n','video','post','FacebookActivityStreamItem',1,'2009-05-21 21:45:50'),(145,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-22 18:36:08',NULL,'wonders why people put up with this police state bullshit.  OMG!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108514165791&amp;h=4VyLp&amp;u=5M5QB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d9240500226b1d1587b91b6027b7cfe9&amp;url=http%3A%2F%2Fwww.wired.com%2Fimages_blogs%2Fthreatlevel%2F2009%2F05%2Ffcc_badge.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-22 18:36:08'),(146,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-23 18:54:32',NULL,'is thinking about taking a long stroll at folklife and stuffing my face for as many hours as possible in the sun today :)',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-23 18:54:32'),(147,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-23 20:15:30',NULL,'just blocked ten people from his newsfeed for taking those obnoxious quizzes.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-23 20:15:30'),(148,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-24 16:52:27',NULL,'is in the midst of having a mindblowingly good weekend!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-25 00:17:39'),(149,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-25 00:37:30',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1810565&amp;id=504883639\nphoto: \n  pid: \"2168458717792280709\"\n  aid: \"2168458717790550922\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_83405843639_504883639_1810565_5659759_s.jpg\ntype: photo\nalt: IMG_1180\n','photo','post','FacebookActivityStreamItem',1,'2009-05-25 00:37:30'),(150,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-26 03:14:20',NULL,'A man with one watch knows what time it is; a man with two watches is never quite sure.  ~Lee Segall',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-26 03:14:20'),(151,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-26 05:41:28',NULL,'is watching this astounding mechanical Lego pirate theater, controlled by Mindstorm/Nextstorm robot Lego, marries the Victorian dramatic clockwork automaton with 21st century cheap computation and precision brick-making. And it\'s got pirates! Seriously, some people have WAAAAY too much time on their hands!','--- \nhref: http://www.facebook.com/ext/share.php?sid=106651591257&amp;h=kdY6S&amp;u=s5j3S\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=e4a2b0b9f01d04041cad03744009e5f6&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FIkDsre1ltvk%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=106651591257#s106651591257\n  source_url: http://www.youtube.com/v/IkDsre1ltvk&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=IkDsre1ltvk&amp;\n  owner: \"504883639\"\nalt: LEGO Mindstorms NXT, Pirates and the NXTfied Theater\n','video','post','FacebookActivityStreamItem',1,'2009-05-26 05:49:14'),(152,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-26 17:00:05',NULL,'it slices!  It dices!  This thing is bad ass!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=81641852983&amp;h=n4lgk&amp;u=_GaYx\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a705865d808e7268740ddbbcd765c8d6&amp;url=http%3A%2F%2Fstatic.gamesbyemail.com%2FNews%2FDiceOMatic%2FCameraLights.jpg%3F633789125654312915&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-26 17:00:05'),(153,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-27 16:24:34',NULL,'so not funny, it\'s funny.  Well, not really.  More just morbidly entertaining...','--- \nhref: http://www.facebook.com/ext/share.php?sid=179221960031&amp;h=B78ga&amp;u=vCExk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=40b122d8dd7a50addbf04cdd51ad440d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FA9QpOfhAPXs%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=179221960031#s179221960031\n  source_url: http://www.youtube.com/v/A9QpOfhAPXs&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=A9QpOfhAPXs&amp;eurl=http://www.cracked.com/blog/i-quit-comedy-the-best-video-of-all-time&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: I\'m on a Couch (The Lonely Island - &quot;I\'m on a Boat&quot; parody spoof)\n','video','post','FacebookActivityStreamItem',1,'2009-05-27 16:24:34'),(154,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-27 20:37:40',NULL,'watching a dude dialup to the Internet using a 1964 300 bps modem.  &lt;geek&gt;','--- \nhref: http://www.facebook.com/ext/share.php?sid=109788136258&amp;h=yWGGN&amp;u=eZd9P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0095242ec2c2bf10e68b1688ccf5a35f&amp;url=http%3A%2F%2Fgadgets.boingboing.net%2F2009%2F05%2F27%2Fstyle%2Fatboingboing.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-28 19:38:38'),(155,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-28 21:01:18',NULL,'totally worth the watch... starts slow builds up to a hilarious result... two baseball teams tired of waiting five hours in a rain delay decide to have a dance off!  They are GOOD!','--- \nhref: http://www.facebook.com/ext/share.php?sid=99311083648&amp;h=Lhn3M&amp;u=hyjHN\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f501750d502ba518131ebeb2b385ec6a&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FaazG7dMhE7I%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=99311083648#s99311083648\n  source_url: http://www.youtube.com/v/aazG7dMhE7I&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=aazG7dMhE7I&amp;eurl=http://ourkitchensink.com/2009/05/27/the-greatest-moment-in-rain-delay-history/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Dance Off USF vs Uconn 2009 Big East Baseball Tournament as seen on PTI.\n','video','post','FacebookActivityStreamItem',1,'2009-05-29 03:50:52'),(156,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-29 03:04:17',NULL,'gives props to Eminem for returning to old form.  WOW.  His new album is *stunning*.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-29 15:14:40'),(157,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-29 15:20:45',NULL,'decision time tonight.  at least my decision is easy!','--- \nhref: http://www.facebook.com/ext/share.php?sid=82828673175&amp;h=yX4sK&amp;u=atDk6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=668c5c66381d93ec70db2dd972a7ef08&amp;url=http%3A%2F%2Fflowingdata.com%2Fwp-content%2Fuploads%2F2009%2F01%2Fgoldstarman2-545x385.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-29 15:23:13'),(158,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-29 16:58:45',NULL,'thinks birds are smart.','--- \nhref: http://www.facebook.com/ext/share.php?sid=105618949438&amp;h=n5fEv&amp;u=9Sg5-\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3f58aa412bc6316764a6c7eac424bb5d&amp;url=http%3A%2F%2Fwww.telegraph.co.uk%2Ftelegraph%2Fmultimedia%2Farchive%2F01111%2Fxelect60_1111910h.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-05-29 16:58:45'),(159,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-29 23:10:13',NULL,'fun!  shot entirely with a still camera (wait till end to see making of)','--- \nhref: http://www.facebook.com/ext/share.php?sid=87034512396&amp;h=rRhGW&amp;u=3eYwl\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=4f7dd0eea4d34686376352078d4ec53c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FPgpRz3RHJMw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=87034512396#s87034512396\n  source_url: http://www.youtube.com/v/PgpRz3RHJMw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=PgpRz3RHJMw&amp;eurl=http://www.boingboing.net/2009/05/29/sorry-im-late-stop-m.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: Sorry i\'m late\n','video','post','FacebookActivityStreamItem',1,'2009-05-29 23:10:13'),(160,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-31 01:15:17',NULL,'had an amazing day with his son, Lena, and Robin - teeball game, miniature golf, trampolines, and building a dam on the beach.  Holy &amp;!@# pure heaven in this weather!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-05-31 01:15:17'),(161,'2009-07-17 02:08:08','2009-07-17 02:08:08','2009-05-31 02:07:41',NULL,'','--- \nname: I farted in your face and then you stole my wallet\nhref: http://www.facebook.com/group.php?gid=81615419170\nfb_object_id: \"81615419170\"\nfb_object_type: group\nicon: http://static.ak.fbcdn.net/images/icons/group.gif?8:25796\nmedia: {}\n\ncaption: Common Interest - Activities\ndescription: Has this happened to you?\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-05-31 02:07:41'),(162,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-01 07:15:38',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843134&amp;id=504883639\nphoto: \n  pid: \"2168458717792313278\"\n  aid: \"2168458717790552260\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs108.snc1/4621_85679763639_504883639_1843134_4182462_s.jpg\ntype: photo\nalt: IMG_1187\n','photo','post','FacebookActivityStreamItem',1,'2009-06-01 07:15:38'),(163,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-01 07:18:38',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1843146&amp;id=504883639\nphoto: \n  pid: \"2168458717792313290\"\n  aid: \"2168458717790552261\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs088.snc1/4621_85680338639_504883639_1843146_7216025_s.jpg\ntype: photo\nalt: IMG_1200\n','photo','post','FacebookActivityStreamItem',1,'2009-06-01 07:18:38'),(164,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-01 18:34:02',NULL,'The Coolest House in the Neighborhood (And Maybe the Galaxy)','--- \nhref: http://www.facebook.com/ext/share.php?sid=180076720315&amp;h=GlJnM&amp;u=rs_SR\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d06b5a211c3893aeca0b1a8a670e6c22&amp;url=http%3A%2F%2Fcdn-i.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17435%2Ffuturehouse_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-01 18:34:02'),(165,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-01 20:13:51',NULL,'Dear Media, I\'ve had enough hearing about Susan Boyle.  KKTHXBAI.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-01 21:55:40'),(166,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-02 20:53:00',NULL,'won a poker tournament last night.  What a rush!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-02 23:00:14'),(167,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-03 01:02:08',NULL,'is melting from the heat',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-03 14:26:12'),(168,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-04 03:01:34',NULL,'totally sacked out for a nap in 85 degree heat with a modicum of clothing on... for three hours... ouch....',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-04 16:28:36'),(169,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-04 05:45:53',NULL,'is starting to think evil thoughts...','--- \nhref: http://www.facebook.com/ext/share.php?sid=101500368271&amp;h=TU3MC&amp;u=DK_Hs\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a6483ba371ea7faa040fca781bc7463d&amp;url=http%3A%2F%2Fhowto.wired.com%2Fmediawiki%2Fimages%2FSt_howto_explodingdrink.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-04 10:13:56'),(170,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-04 20:44:15',NULL,'finally understands the biblical meaning of &quot;Marriage&quot;','--- \nhref: http://www.facebook.com/ext/share.php?sid=105295259883&amp;h=4AOfZ&amp;u=LFkY6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47f44c7b17752fe0548a5ba0d688b4bb&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FOFkeKKszXTw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=105295259883#s105295259883\n  source_url: http://www.youtube.com/v/OFkeKKszXTw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=OFkeKKszXTw\n  owner: \"504883639\"\nalt: Betty Bowers Explains Traditional Marriage to Everyone Else\n','video','post','FacebookActivityStreamItem',1,'2009-06-05 08:31:41'),(171,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-05 16:54:40',NULL,'really, really can\'t stand conan o\'brien.  I\'ve tried.  Three times this week.  To laugh even a little at his tired old schtick.  Sometimes, I laugh during the commercials, but never during the program.  Bed time is at 11:30 for me now apparently :(',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-05 16:54:40'),(172,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-07 02:39:35',NULL,'is having a great day with his son!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-07 02:39:35'),(173,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-08 19:06:39',NULL,'Give me my iPhone 3G 3.0 OS!  I\'ll pass on the hardware upgrade for this generation tho.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-08 19:06:39'),(174,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-09 03:04:38',NULL,'finally an upgrade to my ][GS, I now can get a THREE-GS!  Sweet thanks apple!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-09 03:04:38'),(175,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-09 03:20:16',NULL,'just hid three more friends for taking these totally inane quizzes with artificially random results that just do nothing but clog up my newsfeed.  Die facebook quizzes. Die.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-09 04:16:09'),(176,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-09 23:30:54',NULL,'wants you to check out the new website I did for my girlfriend and let me know what you think.  See if you can find the dirty pics!','--- \nhref: http://www.facebook.com/ext/share.php?sid=103480538944&amp;h=C7yFJ&amp;u=wde24\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a10de2e5a4bf01d31726c7e2610d8f77&amp;url=http%3A%2F%2Fwww.fairmontolympicweddings.com%2Fwp-content%2Fthemes%2Ffairmont%2Fimages%2Fcontent.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-10 07:27:52'),(177,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-10 02:56:15',NULL,'feels GREAT!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108019026344&amp;h=tM7Jg&amp;u=semhb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=df9126c53ac6412f984931658a88de8c&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJC2gIPnUCgw%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=108019026344#s108019026344\n  source_url: http://www.youtube.com/v/JC2gIPnUCgw&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=JC2gIPnUCgw\n  owner: \"504883639\"\nalt: nutrigrain commercial\n','video','post','FacebookActivityStreamItem',1,'2009-06-10 04:15:54'),(178,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-10 06:13:15',NULL,'is enjoying the nice WARM weather.  Not hot.  Not cold.  Just RIGHT.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-10 06:13:15'),(179,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-10 20:05:10',NULL,'has opened Eternos.com for Beta registration.  Please go register your email address to get notified soon as we open for beta!','--- \nhref: http://www.facebook.com/ext/share.php?sid=218902860009&amp;h=ftCC5&amp;u=hs2qW\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=bda5b9c79c7f2f28885c578aef99666a&amp;url=http%3A%2F%2Fwww.eternos.com%2Fimages%2Fbeta.gif%3F1244663389&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-10 20:05:10'),(180,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-10 23:43:05',NULL,'this is why I hate the government.  And some people want them to run health care??  $9 TRILLION dollars in off-balance sheet transactions, and no monitoring system in place for public review?  It really is no joke this country has been sold off in pieces and we all better start learning Chinese.  And I\'m not exaggerating or overreacting.  It\'s pretty sad.','--- \nhref: http://www.facebook.com/ext/share.php?sid=115462236627&amp;h=RUPFY&amp;u=EZhjM\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=a94b39c20594b199be1dce1dbbf2ee52&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FcJqM2tFOxLQ%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=115462236627#s115462236627\n  source_url: http://www.youtube.com/v/cJqM2tFOxLQ&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=cJqM2tFOxLQ&amp;eurl=http://dailybail.com/home/there-are-no-words-to-describe-the-following-part-ii.html&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"High Quality Version: Is Anyone Minding the Store at the Federal Reserve?\"\n','video','post','FacebookActivityStreamItem',1,'2009-06-11 00:12:32'),(181,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-12 01:20:00',NULL,'for some reason it feels like Friday to me today.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-12 05:22:14'),(182,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-12 06:36:35',NULL,'pretty much has the best girlfriend ever!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-12 06:54:07'),(183,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-12 20:15:06',NULL,'anyone want to watch my adorable Pug, Borf, for 10 days starting July 1st while I\'m in Hawaii?  Pleeeeaseeee',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-13 00:37:21'),(184,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-12 23:31:29',NULL,'is in love with the best of the best!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-12 23:31:29'),(185,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-13 04:28:47',NULL,'is now known as http://www.facebook.com/nerolabs  Vanity username for the win!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-13 04:28:47'),(186,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-13 17:51:30',NULL,'is looking at a NATURAL tree fall in West Seattle.  AWESOME!','--- \nhref: http://www.facebook.com/ext/share.php?sid=89287909614&amp;h=gCBLX&amp;u=pSsbK\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7fae08aa639d8494b14ae42f3ee74c29&amp;url=http%3A%2F%2Fwestseattleblog.com%2Fblog%2Fwp-content%2Fuploads%2F2009%2F06%2Fzzmonster.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-13 17:51:30'),(187,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-14 21:08:17',NULL,'Hours of Operation','--- \nhref: http://www.facebook.com/ext/share.php?sid=95673251446&amp;h=IoOd6&amp;u=lHqBi\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=16e0d51c53a84c99b2d8089350decb2f&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3080%2F3152352551_706d9ca6a1_o.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-14 21:08:17'),(188,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-15 00:11:48',NULL,'Sunday is cleaning and bills paying night and getting ready for the next week!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-15 02:41:46'),(189,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-15 03:00:16',NULL,'Gratz to the Lakers.  Kobe, on the other hand, can suck me.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-15 15:46:28'),(190,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-15 23:47:43',NULL,'~32,000 American Scientists Agree:  Global Warming is BULLSHIT','--- \nhref: http://www.facebook.com/ext/share.php?sid=190996770074&amp;h=GHGJU&amp;u=8Lymb\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c635339fa7f617c17b6dc569080115b1&amp;url=http%3A%2F%2Fwww.campaignforliberty.com%2Fimg%2Fauthor%2Fpaul.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-16 04:42:12'),(191,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-16 07:45:08',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1917001&amp;id=504883639\nphoto: \n  pid: \"2168458717792387145\"\n  aid: \"2168458717790555233\"\n  index: \"3\"\n  height: \"403\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v645/77/120/504883639/s504883639_1917001_8036523.jpg\ntype: photo\nalt: 004_4\n','photo','post','FacebookActivityStreamItem',1,'2009-06-16 08:26:42'),(192,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-16 19:08:04',NULL,'wants to be a cat','--- \nhref: http://www.facebook.com/ext/share.php?sid=92502495980&amp;h=IYv8n&amp;u=_jEbo\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f73c0c2216fc5c560994fb53943610c9&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FJ5Xrcp6k8VE%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=92502495980#s92502495980\n  source_url: http://www.youtube.com/v/J5Xrcp6k8VE&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=J5Xrcp6k8VE&amp;eurl=http://www.google.com/reader/view/&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: How catnip gets cats high\n','video','post','FacebookActivityStreamItem',1,'2009-06-16 20:20:33'),(193,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-16 20:59:46',NULL,'thinks Obama is a wolf in sheeps clothing.','--- \nhref: http://www.facebook.com/ext/share.php?sid=91375379508&amp;h=GoMo9&amp;u=RI7y_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=92fae83da333a7ba2d2fb7f127d2a417&amp;url=http%3A%2F%2Fmsnbcmedia.msn.com%2Fj%2FMSNBC%2FComponents%2FBylines%2Fmugs%2FMSNBC%2520Interactive%2Fbill_dedman_2.thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-16 20:59:46'),(194,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-17 00:21:28',NULL,'if you protest the government in any way, you are a terrorist: straight from the Department of Defense','--- \nhref: http://www.facebook.com/ext/share.php?sid=94299282445&amp;h=2C38f&amp;u=jhdhv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=90b8c2b48180923b4cf51402c2dd7569&amp;url=http%3A%2F%2Fwww.infowars.net%2Fpictures%2Fjune2009%2F150609protest.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-17 01:03:42'),(195,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-17 01:11:41',NULL,'updated his theme on his blog... check it out','--- \nhref: http://www.facebook.com/ext/share.php?sid=119626995927&amp;h=6_FZ-&amp;u=rrCEL\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b8ee8cb1c8c76b92a89dd4b0de6875d6&amp;url=http%3A%2F%2Fedmondfamily.com%2Fgallery2%2Fmain.php%3Fg2_view%3Dcore.DownloadItem%26g2_itemId%3D3496%26g2_serialNumber%3D2&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-17 01:11:41'),(196,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-17 22:31:01',NULL,'wonders what &quot;...according to scientists, is that winter temperatures across the Great Plains and Midwest are now some 7Âº warmer than historical norms&quot;.  According to my understanding of the climate, there is NO SUCH THING as a &quot;Historical Norm&quot; when it comes to weather :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=107975996440&amp;h=KPs3X&amp;u=hZDR4\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=756995be59d1549c05817c9ccee0e8e7&amp;url=http%3A%2F%2Fwww.scientificamerican.com%2Fmedia%2Finline%2F000BA112-8AB6-1E83-85F7809EC588EEDF_1_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-23 01:34:37'),(197,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-19 00:52:36',NULL,'is looking forward to FATHERS DAY!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-19 00:52:36'),(198,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-19 15:57:27',NULL,'reading that Pixar sent an employee with a DVD of \'Up\' to a dying girl as a last wish.  One of the most touching stories I\'ve read in a while... get the tissue out...','--- \nhref: http://www.facebook.com/ext/share.php?sid=99373067465&amp;h=49aMl&amp;u=u_-xX\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=05f012078c4310aaa57bdd0cbc8ee6b8&amp;url=http%3A%2F%2Fimages.ocregister.com%2Fnewsimages%2Fcommunity%2Fhuntingtonbeach%2F2009%2F04%2Fcolby_med.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-19 18:52:29'),(199,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-19 16:06:28',NULL,'pretty good tilt-shift + time-lapse video!  Love it!','--- \nhref: http://www.facebook.com/ext/share.php?sid=111180392194&amp;h=LJT_t&amp;u=xnhmY\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b1f09016b22c47e4e3362277947ca1f5&amp;url=http%3A%2F%2Fts.vimeo.com.s3.amazonaws.com%2F155%2F790%2F15579090_160.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=111180392194#s111180392194\n  source_url: http://vimeo.com/moogaloop.swf?clip_id=5137183\n  source_type: html\n  display_url: http://vimeo.com/5137183\n  owner: \"504883639\"\nalt: Bathtub V\n','video','post','FacebookActivityStreamItem',1,'2009-06-19 16:06:28'),(200,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-19 21:21:02',NULL,'just took my dog to the vet.  Stiff muscles and pinched nerve.  Some doggie aspirin and $72 makes it the cheapest vet visit ever!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-19 21:50:58'),(201,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-20 03:19:14',NULL,'does not get his son on Fathers Day, due to his ex being... well... it\'s not polite to say.  GRRRRR',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-21 07:56:17'),(202,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-20 04:13:15',NULL,'Twitter Kills','--- \nhref: http://www.facebook.com/ext/share.php?sid=194616800023&amp;h=Ac9Ve&amp;u=lLmXk\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=884f002049d26adf85337b9e315cb5ab&amp;url=http%3A%2F%2Fwww.austriantimes.at%2Fthumbnails%2F6vkkfvy7_tiny.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-20 05:07:23'),(203,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-20 18:12:25',NULL,'is going on 14 days without seeing or even talking to his son.  Aggressive attorney hired, but legal stuff takes time.  This SUCKS.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-21 17:27:46'),(204,'2009-07-17 02:08:09','2009-07-17 02:08:09','2009-06-21 17:56:47',NULL,'can this be for real?','--- \nhref: http://www.facebook.com/ext/share.php?sid=118330124011&amp;h=gyt0C&amp;u=wG45e\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=66ba91afb2c76e8b3e9c596c7dab0268&amp;url=http%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fa%2Fa4%2FAmphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg%2F240px-Amphibole_-_Cummingtonite_w-_chlorite_in_schist_Magnesium_iron_silicate_3800_foot_level_Homestake_Mine_Lawrence_COunty_South_Dakota_2071.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-21 18:41:06'),(205,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 17:37:54',NULL,'thanks everyone for the wonderful birthday and fathers day wishes.  Keep praying that my lawyer gets my son to our family trip in Hawaii and prevents this type of abuse from happening again.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-22 17:37:54'),(206,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 19:29:12',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952825&amp;id=504883639\nphoto: \n  pid: \"2168458717792422969\"\n  aid: \"2168458717790556509\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v652/77/120/504883639/s504883639_1952825_4167047.jpg\ntype: photo\nalt: IMG_1214\n','photo','post','FacebookActivityStreamItem',1,'2009-06-23 03:54:57'),(207,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 19:39:16',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=1952869&amp;id=504883639\nphoto: \n  pid: \"2168458717792423013\"\n  aid: \"2168458717790556513\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"401\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93156648639_504883639_1952869_6072646_s.jpg\ntype: photo\nalt: Picture 007\n','photo','post','FacebookActivityStreamItem',1,'2009-06-22 20:37:42'),(208,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 19:54:50',NULL,'pretty clever','--- \nhref: http://www.facebook.com/ext/share.php?sid=100941976217&amp;h=7Jk8r&amp;u=CfJh_\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c83bc162dd40d88c02650232aafcf279&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F3eooXNd0heM%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=100941976217#s100941976217\n  source_url: http://www.youtube.com/v/3eooXNd0heM&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=3eooXNd0heM&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: \"Auto-Tune the News #5: lettuce regulation. American blessings.\"\n','video','post','FacebookActivityStreamItem',1,'2009-06-22 19:54:50'),(209,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 20:51:02',NULL,'more proof that if you tell someone something is &quot;green&quot; that they automatically turn their brains off, or maybe it\'s because the green movement allows for zero skepticism without chastisment.  Sounds like the green movement is taking a cue from the right wing zealots that use peer pressure to sell their beliefs, which more often than not are completely erroneous.','--- \nname: US shoppers misled by greenwash, Congress told | Environment | guardian.co.uk\nhref: http://www.facebook.com/ext/share.php?sid=100787792815&amp;h=MoEzB&amp;u=grkH8\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.guardian.co.uk\"\ndescription: 98% of supposedly environmentally friendly products make potentially false or misleading claims, US campaigners say\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-06-22 23:03:45'),(210,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-22 21:00:33',NULL,'is looking for people willing to write a Declaration to the court regarding my most awesome Dadness to Jack, as well as can state their opinion regarding Natalie\'s continued assault on me.  Email me at andrew@andrewedmond.com or call me.  I really need as many people as I can that the court will consider credible witnesses.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-23 16:05:32'),(211,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 03:13:35',NULL,'is celebrating my birthday AND Robin and I\'s six month anniversary tonight!!  Prayers for Jack welcomed from All!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-23 05:40:22'),(212,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 05:40:50',NULL,'just got the hottest, most thoughtful, amazing, kick ass, unbelievable, intense, beautiful, sexy, thoroughly overwhelming birthday present ever from Robin! What a babe!!!!!!!!!!!!!!!!!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-23 17:56:11'),(213,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 18:21:03',NULL,'watching a kid FREAK out when his mom cancels his World of Warcraft account.... right as he hits level 80.','--- \nhref: http://www.facebook.com/ext/share.php?sid=120346397177&amp;h=-nksS&amp;u=pdkIJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=8d954d8254903b7e1348821170b5acba&amp;url=http%3A%2F%2F1.media.collegehumor.com%2Fcollegehumor%2Fch6%2F4%2F4%2Fcollegehumor.4a91d1f46db7c43b1aadf864ab8eed36.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=120346397177#s120346397177\n  source_url: http://www.collegehumor.com/moogaloop/moogaloop.swf?clip_id=1915521&amp;autostart=true\n  source_type: html\n  display_url: http://www.collegehumor.com/video:1915521\n  owner: \"504883639\"\nalt: WoW Freakout\n','video','post','FacebookActivityStreamItem',1,'2009-06-23 23:00:50'),(214,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 20:19:00',NULL,'what an amazing pic!','--- \nhref: http://www.facebook.com/ext/share.php?sid=95087931475&amp;h=PeyhX&amp;u=FtH1t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d33c44e424c9867ffbf9abd89835bb9a&amp;url=http%3A%2F%2Fmsnbcmedia3.msn.com%2Fj%2FMSNBC%2FComponents%2FPhoto%2F_new%2F090622-volcano-hmed2p.hmedium.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-23 20:19:00'),(215,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 20:42:47',NULL,'go go Ron Paul!','--- \nhref: http://www.facebook.com/ext/share.php?sid=112448291083&amp;h=KG3ns&amp;u=qJ-5i\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ac701822824039bb6f753289ae42b930&amp;url=http%3A%2F%2Fwww.lewrockwell.com%2Fpaul%2FGoldPeaceProsperity_T.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-23 22:40:31'),(216,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 20:45:11',NULL,'the truth about family holidays, at last','--- \nname: www.theonion.com\nhref: http://www.facebook.com/ext/share.php?sid=115495881353&amp;h=K1Pxq&amp;u=H8Ftj\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-06-24 03:34:09'),(217,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-23 23:23:40',NULL,'Picture 1','--- \nhref: http://www.facebook.com/photo.php?pid=1960357&amp;id=504883639\nphoto: \n  pid: \"2168458717792430501\"\n  aid: \"2168458717790556751\"\n  index: \"1\"\n  height: \"348\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs110.snc1/4813_93624863639_504883639_1960357_4561644_s.jpg\ntype: photo\nalt: Picture 1\n','photo','post','FacebookActivityStreamItem',1,'2009-06-23 23:23:40'),(218,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 03:33:20',NULL,'pyramids in the USA.  Also for no discernible purpose.  Huh, who knew?','--- \nhref: http://www.facebook.com/ext/share.php?sid=100881712186&amp;h=pfZPj&amp;u=prfle\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=58c5f969b2219dcccf9b2092d016ae88&amp;url=http%3A%2F%2Fwww.boingboing.net%2F000418l3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 03:33:20'),(219,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 05:39:20',NULL,'and we think Iran is effed up?  Really?','--- \nhref: http://www.facebook.com/ext/share.php?sid=107187719051&amp;h=-4SEX&amp;u=VyDWD\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=0537f3dd7048cd052f58cb962d057fe6&amp;url=http%3A%2F%2Fi.cdn.turner.com%2Fcnn%2F2009%2FPOLITICS%2F06%2F23%2FUS.syria.ambassador%2Ftzmos.mitchell.assad.gi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 06:40:58'),(220,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 05:39:54',NULL,'is determined.  Focused.  Wait, what was I saying?',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-24 05:53:28'),(221,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 06:10:52',NULL,'a statement about our post-industrial world.  Sublime.','--- \nhref: http://www.facebook.com/ext/share.php?sid=208344885695&amp;h=D8cUH&amp;u=FGR4V\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=fcb3a8a988ac8536644514b3cf561972&amp;url=http%3A%2F%2Fcraphound.com%2Fimages%2Fgoldi.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 06:10:52'),(222,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 06:19:43',NULL,'get a haircut, please, PLEASE!','--- \nhref: http://www.facebook.com/ext/share.php?sid=107888324048&amp;h=8XTCx&amp;u=Q-Xok\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=2a1e086a9955997b1b71c4cec3e2a61c&amp;url=http%3A%2F%2Finlinethumb05.webshots.com%2F26564%2F2444545680105101600S600x600Q85.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 06:19:43'),(223,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 06:45:59',NULL,'thanks everyone that has pitched in with help for re-establishing EQUAL custody with my son.  Fatherhood is NOT a privilege granted by Moms... but a RIGHT, even though sometimes we have to fight for it.  Soon... soon....',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-24 16:29:48'),(224,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 14:53:54',NULL,'finds it funny that the Toyota Prius takes three times more energy to produce than a Hummer, totally offsetting any conceived &quot;savings&quot; to the environment...','--- \nhref: http://www.facebook.com/ext/share.php?sid=112449587867&amp;h=aIAGQ&amp;u=axm5j\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=b750bd4b494a647bab291644d6f3bfee&amp;url=http%3A%2F%2Fclubs.ccsu.edu%2Frecorder%2F%2Fmain%2Fccsulogo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 14:53:54'),(225,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 15:04:08',NULL,'more environmental shenanigans.  I really wish the green movement had more built in skepticism, but anything goes I supposed!','--- \nhref: http://www.facebook.com/ext/share.php?sid=123982352904&amp;h=utKVR&amp;u=K5J4p\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=974272c296c509112efc3f9cf8377427&amp;url=http%3A%2F%2Fcache.consumerist.com%2Fassets%2Fimages%2F31%2F2009%2F06%2Fpeanut1.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 15:04:08'),(226,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 15:08:55',NULL,'a green movement that helps people save money, educate themselves, and is based on real, factual data... this is something I can support!','--- \nhref: http://www.facebook.com/ext/share.php?sid=108698398616&amp;h=3N6pR&amp;u=MM6IJ\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d8d3cf855dbbdc55463f07b3b5f5b48f&amp;url=http%3A%2F%2Fimages.google.com%2Furl%3Fsource%3Dimgres%26ct%3Dtbn%26q%3Dhttp%3A%2F%2Fblog.infotrends.com%2Fwordpress%2Fwp-content%2Fgallery%2Fgreen-logo%2Fmicrosoft-green_hp.jpg%26usg%3DAFQjCNHJSO4LP0DEMUx9eWR3VY5gMixarQ&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 15:08:55'),(227,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 15:10:12',NULL,'fascinating','--- \nhref: http://www.facebook.com/ext/share.php?sid=113961277027&amp;h=yam5X&amp;u=TAurF\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6190c165eb4071ae3bef699460ee0882&amp;url=http%3A%2F%2Fwww.dailymotion.com%2Fthumbnail%2F160x120%2Fvideo%2Fx4muob_zoom-into-a-tooth_tech&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=113961277027#s113961277027\n  source_url: http://www.dailymotion.com/swf/x4muob?autoPlay=1\n  source_type: html\n  display_url: http://www.dailymotion.com/video/x4muob_zoom-into-a-tooth_tech\n  owner: \"504883639\"\nalt: Dailymotion - Zoom into a Tooth - a Tech &amp; Science video\n','video','post','FacebookActivityStreamItem',1,'2009-06-24 15:10:12'),(228,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 16:09:32',NULL,'Suze Orman tells me a &quot;budget&quot; is like a &quot;diet&quot; for money.  I feel enlightened.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-24 20:43:20'),(229,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 16:23:43',NULL,'funny as hell','--- \nhref: http://www.facebook.com/ext/share.php?sid=94755871589&amp;h=Tl2hj&amp;u=mJI1n\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=47ed67f229dfe2caec6c5e7ee58a1ccc&amp;url=http%3A%2F%2Ftrueslant.com%2Frachelking%2Ffiles%2F2009%2F06%2F300px-virgin_america_a320_cabin.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-24 16:23:43'),(230,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-24 22:12:04',NULL,'So John McCain thinks the president should have responded more harshly to the situation in Iran.  However, from this article: &quot;at the Republican National Committee convention in St. Paul in 2004,  250 protesters were arrested shortly before John McCain took the podium. Most were innocent activists and even journalists.&quot;  What a hypocrite.','--- \nname: \"Informed Comment: Washington and the Iran Protests:\"\nhref: http://www.facebook.com/ext/share.php?sid=94997638190&amp;h=ZKuZX&amp;u=Q-QYw\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: www.juancole.com\"\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-06-25 13:47:13'),(231,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 15:58:50',NULL,'they need to teach a class in facebook etiquette',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-25 16:37:39'),(232,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 16:12:31',NULL,'wow, this is a REAL advertisement for IE8???  WOWOWOWOWO','--- \nhref: http://www.facebook.com/ext/share.php?sid=95526323542&amp;h=wEa1o&amp;u=oYcUG\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3379b4a491cbb4732a88173f1e5ca83d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2F8-9Mjm-Hohc%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=95526323542#s95526323542\n  source_url: http://www.youtube.com/v/8-9Mjm-Hohc&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=8-9Mjm-Hohc&amp;eurl=http://gizmodo.com/5302248/dean-cain-wards-off-puke-and-porn-with-internet-explorer-8-nsfl&amp;feature=player_embedded\n  owner: \"504883639\"\nalt: O.M.G.I.G.P. - Internet Explorer 8\n','video','post','FacebookActivityStreamItem',1,'2009-06-25 20:57:19'),(233,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 16:17:12',NULL,'wants a Cabybara.  Winner to get the first reference to this rodents name (Caplin Rous)','--- \nhref: http://www.facebook.com/ext/share.php?sid=101192687115&amp;h=uRE9J&amp;u=kqO3K\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=7471338a4ffea137061bef8544be0028&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3618%2F3658068677_52d3857f02.jpg%3Fv%3D0&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-25 16:17:12'),(234,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 16:43:45',NULL,'RIP Farrah Fawcet',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-25 16:50:30'),(235,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 18:11:59',NULL,'Ed Macmahon... Farrah Fawcet... Patrik Swayze next?',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-25 21:42:41'),(236,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 21:45:08',NULL,'http://www.tmz.com/2009/06/25/michael-jackson-dies-death-dead-cardiac-arrest/','--- \nhref: http://www.facebook.com/ext/share.php?sid=97219678547&amp;h=E5Abt&amp;u=Yio4N\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=d98fc22bca4166f2d2ff9d12eccc7a97&amp;url=http%3A%2F%2Fwww.blogcdn.com%2Fwww.tmz.com%2Fmedia%2F2009%2F06%2F0625_michael_jackson_ex2.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-25 22:08:36'),(237,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 22:13:10',NULL,'TMZ typically breaks news in advance because they have people on every LA area hospital.  More reputable organizations do not engage in those type of practices.  Despite the ethics, I am 99% sure TMZ is right here, and people at CNN and FOX should at LEAST report that TMZ is reporting rather than BLATANTLY ignoring that report.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-26 01:08:25'),(238,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-25 22:23:17',NULL,'LA TIMES CONFIRMS MJ IS DEAD','--- \nhref: http://www.facebook.com/ext/share.php?sid=108375399592&amp;h=6FZlx&amp;u=8k_0P\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=04659cdefc877c7febbce3f425ff959c&amp;url=http%3A%2F%2Flatimesblogs.latimes.com%2Flanow%2Fktla-logo.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-25 22:23:17'),(239,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-26 01:57:17',NULL,'OMG.  Jeff Goldblum is NOT dead.  Knock it off.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-26 05:15:11'),(240,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-26 13:38:31',NULL,'neat stuff here *thanks sean*','--- \nhref: http://www.facebook.com/ext/share.php?sid=95716179033&amp;h=VRnq_&amp;u=m7d15\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=340bf8dd95f6f5f814cb8ee0e2012458&amp;url=http%3A%2F%2Fwww.webdesignerdepot.com%2Fwp-content%2Fuploads%2Fphoto_manipulation%2Fphoto_manipulation.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-26 13:38:31'),(241,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-26 14:26:02',NULL,'think you gotta know me pretty well to understand this one','--- \nhref: http://www.facebook.com/ext/share.php?sid=97434442218&amp;h=II1iR&amp;u=8Xt45\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=738662a89784f4fdb4418ce8bdaae1d0&amp;url=http%3A%2F%2Fi.dmdentertainment.com%2Ffunpages%2Fcms_content%2F17531%2Fjloh_thumb.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-26 14:26:02'),(242,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-26 19:11:55',NULL,'Good Stuff!','--- \nhref: http://www.facebook.com/ext/share.php?sid=92521878203&amp;h=WS4Cy&amp;u=4xyOv\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=db3c2fc87743b6d992afe575e75b2230&amp;url=http%3A%2F%2Fwww.dailygalaxy.com%2F.a%2F6a00d8341bf7f753ef011571591c67970b-500wi&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-26 19:11:55'),(243,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-26 19:22:49',NULL,'just got out of court.  I won and Jack is going to HAWAII with us in six days!  Thanks everyone for their support!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-27 15:42:26'),(244,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-27 00:31:10',NULL,'just finished the [Frostbitten] achievement!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-27 02:13:29'),(245,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-27 17:41:02',NULL,'ouch  ouch   ouch  my head  ouch',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-27 18:11:16'),(246,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-28 06:12:06',NULL,'oh.. the irony...','--- \nhref: http://www.facebook.com/ext/share.php?sid=95666789393&amp;h=0zkuq&amp;u=jHsHt\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ea8a6ede06cbc087a42220dab7647307&amp;url=http%3A%2F%2Fwww.sfscope.com%2F2009%2F05%2Funthinkable3.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-28 06:12:06'),(247,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-28 21:56:31',NULL,'preparing for Hawaii is stressful!  Getting to Hawaii will be peaceful!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-28 21:56:31'),(248,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-29 05:10:20',NULL,'okay guys, I hate to say it... Carradine, Fawcet, McMahon, Jackson, Mays... we are in the midst of a major celebrity pruning...  I am voting for Swayze next... who else do you think is going to kick the bucket?  Vote now!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-29 21:03:14'),(249,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-29 15:24:59',NULL,'this was an AMAZING Rolling Stone Article about Goldman Sachs, not available online until this guy put it online.  What a read.  Amazing, MUST read story!!','--- \nhref: http://www.facebook.com/ext/share.php?sid=96830267916&amp;h=9vJPR&amp;u=Dv7Mh\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=c989b8093c9356aa494848c030f4d4cc&amp;url=http%3A%2F%2Ffi.somethingawful.com%2Fcustomtitles%2Ftitle-paper_mac.gif&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-29 15:24:59'),(250,'2009-07-17 02:08:10','2009-07-17 02:08:10','2009-06-29 21:04:39',NULL,'just heard a good one... &quot;Billy Mays heard that celebrities die in threes... leave it up to him to throw in an extra for free!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-06-30 00:18:13'),(251,'2009-07-17 02:08:10','2009-07-17 02:08:11','2009-06-30 06:22:30',NULL,'skepticism is a good thing :)','--- \nhref: http://www.facebook.com/ext/share.php?sid=109998674416&amp;h=fpYxP&amp;u=UhTuB\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=6c0f9134ad5b251f4bab2595864e8836&amp;url=http%3A%2F%2Fwww.quarrygirl.com%2Fwp-content%2Fuploads%2F2009%2F06%2Flotus-vegan-tests-570x214.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-30 06:22:30'),(252,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-06-30 17:33:50',NULL,'I\'ll take two','--- \nhref: http://www.facebook.com/ext/share.php?sid=135338090048&amp;h=gTW7A&amp;u=G7y4t\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b4f49c2a5dca9c39a46d3f473150d8a&amp;url=http%3A%2F%2Fwww.blogsmithcdn.com%2Favatar%2Fimages%2F8%2F2706050_64.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-30 19:05:08'),(253,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-06-30 17:37:02',NULL,'where we are staying in Maui, plane leaves in 48 hours!','--- \nhref: http://www.facebook.com/ext/share.php?sid=97812617481&amp;h=me28P&amp;u=cyYJ6\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=ab692551e934f6ec09b7dde55a258de0&amp;url=http%3A%2F%2Fwww.vacationrentalagent.com%2Fimages%2Frentals%2Fp2648_i9_1138229661.jpg&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-06-30 18:56:07'),(254,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-06-30 22:35:33',NULL,'is leaving on a jet plane...',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-01 05:44:25'),(255,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-01 22:51:23',NULL,'on the ferry to go pick up my son for our trip to hawaii. I haven\'t seen him in 24 days, I\'m shaking with excitement!!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-02 15:39:03'),(256,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-01 23:30:25',NULL,'does anyone else have a problem in the case that you advance pay for a service (cell phone minutes, gift cards, transportaion like ferry tickets) and they \'expire\' in 90 days with no possible refund?  How can something digital \'expire\'?  Theivery more like it.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-02 07:16:41'),(257,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-02 03:30:31',NULL,'yep.  the last will of Michael Jackson, scanned in entirety','--- \nhref: http://www.facebook.com/ext/share.php?sid=130220558664&amp;h=97Euj&amp;u=IYsYS\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=3b5de2be5d3e47de2092b8240eb8bfa3&amp;url=http%3A%2F%2Fimg.docstoc.com%2Fthumb%2F100%2F8016703.png&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-07-02 03:38:46'),(258,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-02 15:56:54',NULL,'this is what I plan to do in Hawaii..','--- \nhref: http://www.facebook.com/ext/share.php?sid=98896998621&amp;h=73l62&amp;u=U6W3T\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=f190d45c088f8c836091b2c5abdd7ad6&amp;url=http%3A%2F%2Fmarkmathews.files.wordpress.com%2F2009%2F06%2Fdsc_9802.jpg%3Fw%3D500%26h%3D333&amp;w=130&amp;h=200\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-07-02 16:17:33'),(259,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-02 19:30:34',NULL,'very inspiring...  (mr. jobs has been my hero since I was 11 years old)','--- \nhref: http://www.facebook.com/ext/share.php?sid=94776700767&amp;h=W8bvv&amp;u=GNsr7\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=5da65e9dc881c8fc6152dc531d6b468d&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FD1R-jKKp3NA%2F2.jpg&amp;w=130&amp;h=200\ntype: video\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=94776700767#s94776700767\n  source_url: http://www.youtube.com/v/D1R-jKKp3NA&amp;autoplay=1\n  source_type: html\n  display_url: http://www.youtube.com/watch?v=D1R-jKKp3NA\n  owner: \"504883639\"\nalt: Steve Jobs Stanford Commencement Speech 2005\n','video','post','FacebookActivityStreamItem',1,'2009-07-02 19:30:34'),(260,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-02 20:10:46',NULL,'is heading to Hawaii with the kids at 2:40 today!!  Packed and ready to go.  I really dislike flying!!!  Robin heads out a day later and is flying first class sans kiddos, lucky her!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-08 01:48:40'),(261,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-03 17:38:51',NULL,'what is better than seeing both your kids sit up bolt upright in bed and in unison say &quot;HAWAII!!  LETS GO SWIMMING!!&quot;',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-03 17:38:51'),(262,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-03 20:00:09',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2016963&amp;id=504883639\nphoto: \n  pid: \"2168458717792487107\"\n  aid: \"2168458717790500067\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97226283639_504883639_2016963_17468_s.jpg\ntype: photo\nalt: {}\n\n','photo','post','FacebookActivityStreamItem',1,'2009-07-03 20:00:09'),(263,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-05 02:53:22',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2023666&amp;id=504883639\nphoto: \n  pid: \"2168458717792493810\"\n  aid: \"2168458717790559128\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_97659613639_504883639_2023666_3645362_s.jpg\ntype: photo\nalt: IMG_1246\n','photo','post','FacebookActivityStreamItem',1,'2009-07-05 14:50:25'),(264,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-07 18:23:52',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045780&amp;id=504883639\nphoto: \n  pid: \"2168458717792515924\"\n  aid: \"2168458717790559781\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712603639_504883639_2045780_6002293_s.jpg\ntype: photo\nalt: IMG_1284\n','photo','post','FacebookActivityStreamItem',1,'2009-07-07 18:23:52'),(265,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-07 18:24:42',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045797&amp;id=504883639\nphoto: \n  pid: \"2168458717792515941\"\n  aid: \"2168458717790559782\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2045797_3936659.jpg\ntype: photo\nalt: IMG_1324\n','photo','post','FacebookActivityStreamItem',1,'2009-07-07 18:24:42'),(266,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-07 18:29:16',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2045818&amp;id=504883639\nphoto: \n  pid: \"2168458717792515962\"\n  aid: \"2168458717790559785\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98714653639_504883639_2045818_2842033_s.jpg\ntype: photo\nalt: IMG_2305\n','photo','post','FacebookActivityStreamItem',1,'2009-07-07 18:29:16'),(267,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-08 00:47:51',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047298&amp;id=504883639\nphoto: \n  pid: \"2168458717792517442\"\n  aid: \"2168458717790559838\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98835568639_504883639_2047298_5035742_s.jpg\ntype: photo\nalt: IMG_1341\n','photo','post','FacebookActivityStreamItem',1,'2009-07-08 00:47:51'),(268,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-08 01:20:09',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2047415&amp;id=504883639\nphoto: \n  pid: \"2168458717792517559\"\n  aid: \"2168458717790559844\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/s504883639_2047415_6779141.jpg\ntype: photo\nalt: IMG_2359\n','photo','post','FacebookActivityStreamItem',1,'2009-07-08 08:05:48'),(269,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-08 09:44:27',NULL,'can\'t even begin to describe the love and affection for my fam, my new one with Jack and Lena and Robin, and my old one with Trev, Keenan, Ryan and Mima!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-08 09:44:27'),(270,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-08 21:39:07',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2051914&amp;id=504883639\nphoto: \n  pid: \"2168458717792522058\"\n  aid: \"2168458717790560009\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99164403639_504883639_2051914_3841018_s.jpg\ntype: photo\nalt: IMG_2429\n','photo','post','FacebookActivityStreamItem',1,'2009-07-09 04:49:48'),(271,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-09 07:49:25',NULL,'just dropped off Robin and Lena at the airport... one more day in Maui then back to ... reality, oh noes!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-09 09:58:27'),(272,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-09 21:11:57',NULL,'is dreading his flight home.  When are scientists going to invent a matter transportation / teleportation device.  I\'d pay double.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-10 01:52:07'),(273,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-09 23:57:29',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2057974&amp;id=504883639\nphoto: \n  pid: \"2168458717792528118\"\n  aid: \"2168458717790560214\"\n  index: \"3\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591663639_504883639_2057974_4968127_s.jpg\ntype: photo\nalt: IMG_1386\n','photo','post','FacebookActivityStreamItem',1,'2009-07-09 23:57:29'),(274,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-09 23:59:45',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2058002&amp;id=504883639\nphoto: \n  pid: \"2168458717792528146\"\n  aid: \"2168458717790560215\"\n  index: \"3\"\n  height: \"604\"\n  owner: \"504883639\"\n  width: \"453\"\nsrc: http://photos-c.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592463639_504883639_2058002_1414467_s.jpg\ntype: photo\nalt: IMG_2479\n','photo','post','FacebookActivityStreamItem',1,'2009-07-09 23:59:45'),(275,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-10 00:11:03',NULL,'Last day in Hawaii and looking very very tan :)','--- \nhref: http://www.facebook.com/photo.php?pid=2058068&amp;id=504883639\nsrc: http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99593833639_504883639_2058068_5149723_s.jpg\ntype: link\n','link','post','FacebookActivityStreamItem',1,'2009-07-10 00:11:03'),(276,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-10 13:22:59',NULL,'ouch. Back in Seattle on a redeye I didn\'t sleep on. Jet lag will suck for a couple days. Today especially. I\'ll be around but napping till hopefully I get fully adjusted tomorrow. Got to see my girls this morning and that is great!!!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-10 14:57:58'),(277,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-10 23:22:13',NULL,'rested, still a little jet lagged, trying to catch up, plan to be putting in 14 hour days till I\'m back on pace.',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-12 04:35:24'),(278,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-11 00:24:59',NULL,'OMG ROFLMOA!','--- \nname: Morgan Spurlock\'s Experiment To Try Heroin For 30 Days Enters 200th Day | The Onion - America\'s Fine\nhref: http://www.facebook.com/ext/share.php?sid=96378168341&amp;h=oGqAq&amp;u=lAx8b\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/news.gif?8:25796\nmedia: {}\n\ncaption: \"Source: www.theonion.com\"\ndescription: files/radionews/06-192 Morgan Spurlock _F.mp3\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-07-11 00:24:59'),(279,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-11 20:37:14',NULL,'West Seattle Street Fair and 85 degrees.  Good times!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-11 20:37:14'),(280,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-12 04:22:33',NULL,'','--- \nhref: http://www.facebook.com/photo.php?pid=2070133&amp;id=504883639\nphoto: \n  pid: \"2168458717792540277\"\n  aid: \"2168458717790560616\"\n  index: \"2\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_100385838639_504883639_2070133_4101049_s.jpg\ntype: photo\nalt: IMG_0496\n','photo','post','FacebookActivityStreamItem',1,'2009-07-12 04:22:33'),(281,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-12 21:13:13',NULL,'Home plate seats!!','--- \nhref: http://www.facebook.com/photo.php?pid=2075720&amp;id=504883639\nphoto: \n  pid: \"2168458717792545864\"\n  aid: \"2168458717790500067\"\n  index: \"1\"\n  height: \"453\"\n  owner: \"504883639\"\n  width: \"604\"\nsrc: http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_100641573639_504883639_2075720_8038526_s.jpg\ntype: photo\nalt: Home plate seats!!\n','photo','post','FacebookActivityStreamItem',1,'2009-07-13 01:25:00'),(282,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-13 04:37:18',NULL,'sneezing',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-13 06:20:30'),(283,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-13 20:34:23',NULL,'please, please let me stop looking!','--- \nname: PingWire\nhref: http://www.facebook.com/ext/share.php?sid=101643409906&amp;h=K7BrY&amp;u=pNpJM\nfb_object_id: {}\n\nfb_object_type: {}\n\nicon: http://static.ak.fbcdn.net/images/icons/post.gif?8:26575\nmedia: {}\n\ncaption: \"Source: pingwire.com\"\ndescription: PingWire is an (almost) live feed of images being posted to Twitpic. Clicking on a thumbnail will take you to the full sized photo.\nproperties: {}\n\n','generic','post','FacebookActivityStreamItem',1,'2009-07-13 20:34:23'),(284,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-14 02:02:50',NULL,'is looking for a really smart MySQL person to answer a few tricky questions',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-14 02:22:30'),(285,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-14 14:45:08',NULL,'up early with a lot to do',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-14 14:45:08'),(286,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-15 03:21:50',NULL,'AMERICAN LEAGUE RULES!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-15 03:33:07'),(287,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-15 16:18:12',NULL,'thinks Michael Arrington has some huge cajones, wow!',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-15 16:18:12'),(288,'2009-07-17 02:08:11','2009-07-17 02:08:11','2009-07-16 00:26:52',NULL,'die facebook quizzes die.  why do some of my friends take 10 quizzes and post them to my feed?  please, facebook, make it stop',NULL,NULL,'status','FacebookActivityStreamItem',1,'2009-07-16 13:45:30'),(289,'2009-07-17 05:09:51','2009-07-17 05:09:52','2009-07-07 23:40:08','2523313695','hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:40:08 +0000 2009\nfavorited: false\ntext: hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;\nid: 2523313695\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(290,'2009-07-17 05:09:52','2009-07-17 05:09:52','2009-07-07 23:39:37','2523306624','again and again','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:37 +0000 2009\nfavorited: false\ntext: again and again\nid: 2523306624\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(291,'2009-07-17 05:09:52','2009-07-17 05:09:52','2009-07-07 23:39:27','2523304410','I am testing the twitter timeline','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:27 +0000 2009\nfavorited: false\ntext: I am testing the twitter timeline\nid: 2523304410\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(292,'2009-07-17 15:50:37','2009-07-17 15:50:37','2009-07-07 23:40:08','2523313695','hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:40:08 +0000 2009\nfavorited: false\ntext: hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;\nid: 2523313695\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(293,'2009-07-17 15:50:37','2009-07-17 15:50:37','2009-07-07 23:39:37','2523306624','again and again','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:37 +0000 2009\nfavorited: false\ntext: again and again\nid: 2523306624\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(294,'2009-07-17 15:50:37','2009-07-17 15:50:37','2009-07-07 23:39:27','2523304410','I am testing the twitter timeline','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:27 +0000 2009\nfavorited: false\ntext: I am testing the twitter timeline\nid: 2523304410\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(295,'2009-07-17 16:09:17','2009-07-17 16:09:18','2009-07-07 23:40:08','2523313695','hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:40:08 +0000 2009\nfavorited: false\ntext: hoo fun indeed some links please &lt;a href=\"http://eternos.com\"&gt;Eternos&lt;/a&gt;\nid: 2523313695\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(296,'2009-07-17 16:09:18','2009-07-17 16:09:18','2009-07-07 23:39:37','2523306624','again and again','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:37 +0000 2009\nfavorited: false\ntext: again and again\nid: 2523306624\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL),(297,'2009-07-17 16:09:18','2009-07-17 16:09:18','2009-07-07 23:39:27','2523304410','I am testing the twitter timeline','--- !map:Mash \nname: eternos tester\ntruncated: false\ncreated_at: Tue Jul 07 23:39:27 +0000 2009\nfavorited: false\ntext: I am testing the twitter timeline\nid: 2523304410\nin_reply_to_user_id: \nsource: web\nin_reply_to_screen_name: \nuser: \nin_reply_to_status_id: \nscreen_name: eternostest\n',NULL,'status','TwitterActivityStreamItem',1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `activity_streams`
--

LOCK TABLES `activity_streams` WRITE;
/*!40000 ALTER TABLE `activity_streams` DISABLE KEYS */;
INSERT INTO `activity_streams` VALUES (1,2,NULL),(2,3,NULL),(3,4,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `address_books`
--

LOCK TABLES `address_books` WRITE;
/*!40000 ALTER TABLE `address_books` DISABLE KEYS */;
INSERT INTO `address_books` VALUES (1,1,'Hermann','Adams',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 05:27:32','2009-07-13 05:27:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,2,'Marc','Mauger',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-16 18:11:34','2009-07-16 18:11:34',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,3,'dr','phil',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-27 17:09:38','2009-07-27 17:09:38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,4,'crap','tastical',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-28 23:32:32','2009-07-28 23:32:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
  `mailbox` varchar(255) default NULL,
  `size` int(11) default NULL,
  `s3_key` varchar(255) default NULL,
  `upload_errors` text,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_emails_on_backup_source_id` (`backup_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_emails`
--

LOCK TABLES `backup_emails` WRITE;
/*!40000 ALTER TABLE `backup_emails` DISABLE KEYS */;
INSERT INTO `backup_emails` VALUES (6,4,'855d09d847d83a8c8bd3bf9317756904','Google Email Verification','--- \n- accounts-noreply@google.com\n','2009-07-09 17:46:47','2009-07-17 02:05:33','2009-07-17 02:05:33',NULL,NULL,NULL,NULL,NULL),(7,4,'4cb024637c666ae52322e04a60174610','Import your contacts and old email','--- \n- mail-noreply@google.com\n','2009-07-09 16:37:11','2009-07-17 02:05:33','2009-07-17 02:05:33',NULL,NULL,NULL,NULL,NULL),(8,4,'f1501d8bdc19acac0f7381e65d6e2a30','Customize Gmail with colors and themes','--- \n- mail-noreply@google.com\n','2009-07-09 16:37:11','2009-07-17 02:05:33','2009-07-17 02:05:33',NULL,NULL,NULL,NULL,NULL),(9,4,'bdcf1646a2b4b86f88daa0b8e1a8a39e','testing send','--- \n- eternosdude@gmail.com\n','2009-07-09 16:37:47','2009-07-26 20:21:15','2009-07-26 20:21:15','[Gmail]/All Mail',723,'[Gmail]_All Mail:bdcf1646a2b4b86f88daa0b8e1a8a39e:4',NULL,NULL),(10,1,'foooo\n',NULL,NULL,NULL,'2009-07-27 20:22:23','2009-07-27 20:22:42','foo',NULL,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_jobs`
--

LOCK TABLES `backup_jobs` WRITE;
/*!40000 ALTER TABLE `backup_jobs` DISABLE KEYS */;
INSERT INTO `backup_jobs` VALUES (1,NULL,0,'fail',1,1,'2009-07-16 20:46:58','2009-07-16 20:56:59','2009-07-16 20:56:59','--- \n- Timed out\n'),(2,NULL,0,'fail',2,1,'2009-07-16 20:55:29','2009-07-16 21:05:30','2009-07-16 21:05:30','--- \n- Timed out\n'),(3,NULL,0,'fail',2,1,'2009-07-16 21:02:44','2009-07-16 21:12:44','2009-07-16 21:12:44','--- \n- Timed out\n'),(4,NULL,0,'ok',2,0,'2009-07-16 21:15:54','2009-07-16 21:16:00','2009-07-16 21:16:00','--- []\n\n'),(5,NULL,0,'ok',2,0,'2009-07-16 21:39:19','2009-07-16 21:39:22','2009-07-16 21:39:22','--- []\n\n'),(6,NULL,0,'ok',2,0,'2009-07-16 21:42:55','2009-07-16 21:42:57','2009-07-16 21:42:57','--- []\n\n'),(7,NULL,0,'ok',2,0,'2009-07-16 21:45:58','2009-07-16 21:46:01','2009-07-16 21:46:01','--- []\n\n'),(8,NULL,0,'ok',2,0,'2009-07-16 21:50:00','2009-07-16 21:50:03','2009-07-16 21:50:03','--- []\n\n'),(9,NULL,0,'fail',1,1,'2009-07-16 21:53:00','2009-07-16 22:03:00','2009-07-16 22:03:00','--- \n- Timed out\n'),(10,NULL,0,'ok',2,0,'2009-07-17 00:56:13','2009-07-17 00:56:15','2009-07-17 00:56:15','--- []\n\n'),(11,NULL,0,'ok',2,0,'2009-07-17 00:56:22','2009-07-17 00:56:25','2009-07-17 00:56:25','--- []\n\n'),(12,NULL,0,'ok',2,0,'2009-07-17 00:57:36','2009-07-17 00:57:38','2009-07-17 00:57:38','--- []\n\n'),(13,NULL,NULL,NULL,1,0,'2009-07-17 00:57:43','2009-07-17 00:57:43',NULL,NULL),(14,NULL,NULL,NULL,1,0,'2009-07-17 00:57:44','2009-07-17 00:57:44',NULL,NULL),(15,NULL,NULL,NULL,1,0,'2009-07-17 00:57:45','2009-07-17 00:57:45',NULL,NULL),(16,NULL,NULL,NULL,1,0,'2009-07-17 00:57:45','2009-07-17 00:57:45',NULL,NULL),(17,NULL,0,'failed',2,0,'2009-07-17 01:36:50','2009-07-17 01:36:54','2009-07-17 01:36:54','--- \n- - Error logging in to Facebook\n  - Login failed\n'),(18,NULL,0,'failed',2,0,'2009-07-17 01:48:56','2009-07-17 01:48:57','2009-07-17 01:48:57','--- \n- - Error logging in to Facebook\n  - Login failed\n'),(19,NULL,0,'failed',2,0,'2009-07-17 01:50:38','2009-07-17 01:50:38','2009-07-17 01:50:38','--- \n- - Error logging in to Facebook\n  - Login failed\n'),(20,NULL,0,'fail',2,1,'2009-07-17 02:03:57','2009-07-17 02:13:58','2009-07-17 02:13:58','--- \n- Timed out\n'),(21,NULL,0,'ok',2,0,'2009-07-17 02:05:29','2009-07-17 02:05:33','2009-07-17 02:05:33','--- []\n\n'),(22,NULL,0,'ok',1,0,'2009-07-17 02:05:54','2009-07-17 02:08:12','2009-07-17 02:08:12','--- []\n\n'),(23,NULL,0,'fail',2,1,'2009-07-17 02:11:46','2009-07-17 02:21:47','2009-07-17 02:21:47','--- \n- Timed out\n'),(24,NULL,0,'ok',2,0,'2009-07-17 02:22:27','2009-07-17 02:22:31','2009-07-17 02:22:31','--- []\n\n'),(25,NULL,0,'ok',2,0,'2009-07-17 02:56:40','2009-07-17 02:56:48','2009-07-17 02:56:48','--- \n- - |-\n    Error saving tweets: You have a nil object when you didn\'t expect it!\n    The error occurred while evaluating nil.items\n'),(26,NULL,0,'ok',2,0,'2009-07-17 05:00:35','2009-07-17 05:00:37','2009-07-17 05:00:37','--- \n- - \"Error saving tweets: can\'t convert NilClass into time\"\n'),(27,NULL,0,'ok',2,0,'2009-07-17 05:05:57','2009-07-17 05:05:58','2009-07-17 05:05:58','--- \n- - \"Error saving tweets: can\'t convert NilClass into time\"\n'),(28,NULL,0,'ok',2,0,'2009-07-17 05:09:49','2009-07-17 05:09:53','2009-07-17 05:09:53','--- []\n\n'),(29,NULL,0,'fail',2,1,'2009-07-17 14:14:57','2009-07-17 14:24:57','2009-07-17 14:24:57','--- \n- Timed out\n'),(30,NULL,0,'fail',2,1,'2009-07-17 14:44:18','2009-07-17 14:54:19','2009-07-17 14:54:19','--- \n- Timed out\n'),(31,NULL,0,'fail',2,1,'2009-07-17 15:19:47','2009-07-17 15:29:48','2009-07-17 15:29:48','--- \n- Timed out\n'),(32,NULL,0,'ok',2,0,'2009-07-17 16:09:16','2009-07-17 16:09:18','2009-07-17 16:09:18','--- []\n\n'),(33,NULL,0,'ok',2,0,'2009-07-17 19:52:21','2009-07-17 19:52:32','2009-07-17 19:52:32','--- []\n\n'),(34,NULL,NULL,NULL,2,0,'2009-07-22 18:23:17','2009-07-22 18:23:17',NULL,NULL),(35,NULL,NULL,NULL,1,0,'2009-07-22 18:23:18','2009-07-22 18:23:18',NULL,NULL),(36,NULL,0,'ok',2,0,'2009-07-26 20:21:11','2009-07-26 20:21:18','2009-07-26 20:21:18','--- []\n\n'),(37,NULL,NULL,NULL,2,0,'2009-07-26 20:21:11','2009-07-26 20:21:11',NULL,NULL),(38,NULL,0,'ok',2,0,'2009-07-27 03:33:37','2009-07-27 03:33:39','2009-07-27 03:33:39','--- []\n\n'),(39,NULL,0,'fail',2,1,'2009-07-29 04:45:18','2009-07-29 08:45:19','2009-07-29 08:45:19','--- \n- Timed out\n'),(40,NULL,0,'fail',2,1,'2009-07-29 05:10:39','2009-07-29 09:10:39','2009-07-29 09:10:39','--- \n- Timed out\n'),(41,NULL,0,'fail',2,1,'2009-07-29 05:12:48','2009-07-29 09:12:48','2009-07-29 09:12:48','--- \n- Timed out\n'),(42,NULL,NULL,NULL,2,0,'2009-07-29 16:46:02','2009-07-29 16:46:02',NULL,NULL),(43,NULL,NULL,NULL,2,0,'2009-07-30 21:45:54','2009-07-30 21:45:54',NULL,NULL),(44,NULL,NULL,NULL,2,0,'2009-07-30 21:45:54','2009-07-30 21:45:54',NULL,NULL),(45,NULL,NULL,NULL,2,0,'2009-07-30 21:45:54','2009-07-30 21:45:54',NULL,NULL);
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
  `cover_id` varchar(255) default NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_photo_albums`
--

LOCK TABLES `backup_photo_albums` WRITE;
/*!40000 ALTER TABLE `backup_photo_albums` DISABLE KEYS */;
INSERT INTO `backup_photo_albums` VALUES (1,1,'2168458722085437437','2168458717792516589',16,'Profile Pictures','','2009-07-13 05:27:41','2009-07-13 05:27:41','','1246998729'),(2,1,'2168458717790500067','2168458717792545864',19,'Mobile Uploads','','2009-07-13 05:27:44','2009-07-13 05:27:44','','1247433192'),(3,1,'2168458717790560616','2168458717792540276',2,'Last Import','','2009-07-13 05:27:47','2009-07-13 05:27:47','','1247372554'),(4,1,'2168458717790560215','2168458717792528144',72,'Jul 9, 2009','','2009-07-13 05:27:52','2009-07-13 05:27:52','','1247188013'),(5,1,'2168458717790560214','2168458717792528116',26,'Hawaii 2009','','2009-07-13 05:27:57','2009-07-13 05:27:57','','1247269149'),(6,1,'2168458717790560009','2168458717792522056',33,'Hawaii 2009 - Mom\'s Camera','','2009-07-13 05:28:01','2009-07-13 05:28:01','','1247089301'),(7,1,'2168458717790559844','2168458717792517557',27,'Hawaii 2009','','2009-07-13 05:28:05','2009-07-13 05:28:05','','1247016115'),(8,1,'2168458717790559838','2168458717792517440',35,'Hawaii 2009','','2009-07-13 05:28:09','2009-07-13 05:28:09','','1247014161'),(9,1,'2168458717790559785','2168458717792515960',39,'Hawaii 2009 - Mom\'s Camera','','2009-07-13 05:28:14','2009-07-13 05:28:14','','1246991513'),(10,1,'2168458717790559782','2168458717792515937',14,'Jul 6, 2009','','2009-07-13 05:28:17','2009-07-13 05:28:17','','1246991131'),(11,1,'2168458717790559781','2168458717792515922',12,'Hawaii 2009','','2009-07-13 05:28:20','2009-07-13 05:28:20','','1246991059'),(12,1,'2168458717790559128','2168458717792493808',32,'Hawaii 2009','','2009-07-13 05:28:24','2009-07-13 05:28:24','','1246763230'),(13,1,'2168458717790556751','2168458717792430501',1,'robin','','2009-07-13 05:28:27','2009-07-13 05:28:27','','1245799420'),(14,1,'2168458717790556513','2168458717792423010',31,'Old Pics','','2009-07-13 05:28:31','2009-07-13 05:28:31','','1245699950'),(15,1,'2168458717790556509','2168458717792422967',15,'Fathers Day 2009','','2009-07-13 05:28:34','2009-07-13 05:28:34','','1245699061'),(16,1,'2168458717790555233','2168458717792387143',3,'Aug 1, 2007','','2009-07-13 05:28:37','2009-07-13 05:28:37','','1245138310'),(17,1,'2168458717790552261','2168458717792313288',6,'May 30, 2009','','2009-07-13 05:28:39','2009-07-13 05:28:39','','1243840732'),(18,1,'2168458717790552260','2168458717792313276',8,'Teeball','','2009-07-13 05:28:42','2009-07-13 05:28:42','','1243840547'),(19,1,'2168458717790550922','2168458717792280708',2,'Memorial Day','','2009-07-13 05:28:45','2009-07-13 05:28:45','','1243211851'),(20,1,'2168458717790549528','2168458717792245666',1,'Beach Day with Uncle Trev','','2009-07-13 05:28:47','2009-07-13 05:28:47','','1242600480'),(21,1,'2168458717790549524','2168458717792245591',20,'Beach Day with Uncle Trev','','2009-07-13 05:28:50','2009-07-13 05:28:50','','1242600193'),(22,1,'2168458717790547785','2168458717792205620',6,'Robin Fairmont Site Pics','','2009-07-13 05:28:53','2009-07-13 05:28:53','','1241818149'),(23,1,'2168458717790545840','2168458717792161830',1,'Nov 3, 2007','','2009-07-13 05:28:55','2009-07-13 05:28:55','','1240938371'),(24,1,'2168458717790544072','2168458717792123626',1,'Kareoke','','2009-07-13 05:28:58','2009-07-13 05:28:58','','1240162004'),(25,1,'2168458717790542581','2168458717792090624',24,'April 2009','','2009-07-13 05:29:01','2009-07-13 05:29:01','','1239560563'),(26,1,'2168458717790540006','2168458717792032931',5,'Mar 28, 2009','','2009-07-13 05:29:04','2009-07-13 05:29:04','','1238293010'),(27,1,'2168458717790505965','2168458717791299482',18,'Burning Man 2008','','2009-07-13 05:29:07','2009-07-13 05:29:07','Black Rock Desert','1238207989'),(28,1,'2168458717790536453','2168458717791956112',4,'My Dad as a Kid','','2009-07-13 05:29:10','2009-07-13 05:29:10','','1236614193'),(29,1,'2168458717790535903','2168458717791943969',3,'Jack Weekend March 06 2009','','2009-07-13 05:29:12','2009-07-13 05:29:12','','1236367642'),(30,1,'2168458717790535737','2168458717791940784',4,'Old Scanned Photos','','2009-07-13 05:29:15','2009-07-13 05:29:15','','1236286370'),(31,1,'2168458717790534817','2168458717791919965',18,'February 2009 - End','','2009-07-13 05:29:18','2009-07-13 05:29:18','','1235894458'),(32,1,'2168458717790533166','2168458717791887397',12,'Mar 23, 2008','','2009-07-13 05:29:21','2009-07-13 05:29:21','','1235111348'),(33,1,'2168458717790533157','2168458717791887197',15,'Nov 28, 2007','','2009-07-13 05:29:24','2009-07-13 05:29:24','','1235106431'),(34,1,'2168458717790533162','2168458717791887306',7,'Serena\'s Wedding','','2009-07-13 05:29:27','2009-07-13 05:29:27','','1235106387'),(35,1,'2168458717790533159','2168458717791887237',60,'Legoland 2007','','2009-07-13 05:29:31','2009-07-13 05:29:31','','1235106112'),(36,1,'2168458717790533160','2168458717791887271',1,'Dec 8, 2007','','2009-07-13 05:29:35','2009-07-13 05:29:35','','1235105718'),(37,1,'2168458717790533137','2168458717791886828',26,'February 18th','','2009-07-13 05:29:38','2009-07-13 05:29:38','','1235096601'),(38,1,'2168458717790533125','2168458717791886579',23,'Feb 13-19th, 2009','','2009-07-13 05:29:42','2009-07-13 05:29:42','','1235094078'),(39,1,'2168458717790531717','2168458717791856983',4,'Feb 8, 2009','','2009-07-13 05:29:45','2009-07-13 05:29:45','','1234396203'),(40,1,'2168458717790528923','2168458717791798566',2,'Sep 21, 2008','','2009-07-13 05:29:47','2009-07-13 05:29:47','Jeep Accident','1233195057'),(41,1,'2168458717790527242','2168458717791763218',33,'Whistler 2009!','','2009-07-13 05:29:51','2009-07-13 05:29:51','whistler, canada','1232437025'),(42,1,'2168458717790526044','2168458717791736987',11,'Bowling and Skating Day','','2009-07-13 05:29:54','2009-07-13 05:29:54','Lynnwood','1231881246'),(43,1,'2168458717790521634','2168458717791638090',3,'Snow Day 2008','','2009-07-13 05:29:57','2009-07-13 05:29:57','Vashon Island','1230018630'),(44,1,'2168458717790517869','2168458717791560985',18,'Some New Pics','','2009-07-13 05:29:59','2009-07-13 05:29:59','','1229025019'),(45,1,'2168458717790517526','2168458717791554187',2,'Thanksgiving 2008','','2009-07-13 05:30:02','2009-07-13 05:30:02','','1227832088'),(46,1,'2168458717790513271','2168458717791463675',8,'Halloween 2008','','2009-07-13 05:30:05','2009-07-13 05:30:05','','1225557309'),(47,1,'2168458717790513181','2168458717791461811',1,'Old High School Pics','','2009-07-13 05:30:08','2009-07-13 05:30:08','','1225511339'),(48,17,'4319609151169757181','4319609146905062047',2,'Profile Pictures','','2009-07-17 19:52:24','2009-07-17 19:52:24','','1231385536'),(49,17,'4319609146876815624','4319609146905288119',2,'Random','','2009-07-17 19:52:27','2009-07-17 19:52:27','Home &amp; About','1244850471');
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
  `download_error` text,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_backup_photos_on_backup_photo_album_id` (`backup_photo_album_id`),
  KEY `index_backup_photos_on_source_photo_id` (`source_photo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=729 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_photos`
--

LOCK TABLES `backup_photos` WRITE;
/*!40000 ALTER TABLE `backup_photos` DISABLE KEYS */;
INSERT INTO `backup_photos` VALUES (29,2,'2168458717791253820',90,'2009-07-13 05:27:45','2009-08-11 20:03:04','http://photos-e.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_783676_6712.jpg','',NULL,NULL,'downloaded'),(42,4,'2168458717792528148',74,'2009-07-13 05:27:52','2009-08-11 20:01:28','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99592498639_504883639_2058004_5913409_n.jpg','IMG_2483',NULL,NULL,'downloaded'),(46,4,'2168458717792528152',83,'2009-07-13 05:27:52','2009-08-11 20:02:22','http://photos-a.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99592608639_504883639_2058008_1604007_n.jpg','IMG_2487',NULL,NULL,'downloaded'),(115,5,'2168458717792528121',86,'2009-07-13 05:27:57','2009-08-11 20:02:43','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591718639_504883639_2057977_4284778_n.jpg','IMG_1389',NULL,NULL,'downloaded'),(120,5,'2168458717792528126',85,'2009-07-13 05:27:57','2009-08-11 20:02:34','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_99591798639_504883639_2057982_4276738_n.jpg','IMG_1394',NULL,NULL,'downloaded'),(125,5,'2168458717792528131',70,'2009-07-13 05:27:57','2009-08-11 20:01:04','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_99591888639_504883639_2057987_8359997_n.jpg','IMG_2559',NULL,NULL,'downloaded'),(194,7,'2168458717792517587',77,'2009-07-13 05:28:06','2009-08-11 20:01:47','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2047443_2729318.jpg','IMG_2422',NULL,NULL,'downloaded'),(254,9,'2168458717792515985',72,'2009-07-13 05:28:14','2009-08-11 20:01:16','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715328639_504883639_2045841_515771_n.jpg','IMG_2334',NULL,NULL,'downloaded'),(257,9,'2168458717792515988',82,'2009-07-13 05:28:14','2009-08-11 20:02:16','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98715413639_504883639_2045844_1925682_n.jpg','IMG_2337',NULL,NULL,'downloaded'),(262,9,'2168458717792515993',81,'2009-07-13 05:28:14','2009-08-11 20:02:10','http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs137.snc1/5851_98715593639_504883639_2045849_4000641_n.jpg','IMG_2347',NULL,NULL,'downloaded'),(294,11,'2168458717792515932',68,'2009-07-13 05:28:21','2009-08-11 20:00:54','http://photos-e.ak.fbcdn.net/hphotos-ak-snc1/hs157.snc1/5851_98712838639_504883639_2045788_6144862_n.jpg','IMG_1315',NULL,NULL,'downloaded'),(322,12,'2168458717792493861',76,'2009-07-13 05:28:24','2009-08-11 20:01:39','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023717_1569920.jpg','IMG_1275',NULL,NULL,'downloaded'),(327,12,'2168458717792493875',73,'2009-07-13 05:28:25','2009-08-11 20:01:22','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v5207/77/120/504883639/n504883639_2023731_4398497.jpg','IMG_1280',NULL,NULL,'downloaded'),(413,21,'2168458717792245590',75,'2009-07-13 05:28:50','2009-08-11 20:01:33','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/4332_81109478639_504883639_1775446_390134_n.jpg','IMG_1159',NULL,NULL,'downloaded'),(417,22,'2168458717792205622',69,'2009-07-13 05:28:53','2009-08-11 20:00:59','http://photos-g.ak.fbcdn.net/hphotos-ak-snc1/hs032.snc1/3220_78327208639_504883639_1735478_584478_n.jpg','Azzura_Photography_Finals_3_resize',NULL,NULL,'downloaded'),(424,25,'2168458717792090625',88,'2009-07-13 05:29:01','2009-08-11 20:02:52','http://photos-b.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620481_5681139.jpg','IMG_1070',NULL,NULL,'downloaded'),(433,25,'2168458717792090634',71,'2009-07-13 05:29:01','2009-08-11 20:01:11','http://photos-c.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620490_4511604.jpg','IMG_1097',NULL,NULL,'downloaded'),(439,25,'2168458717792090640',84,'2009-07-13 05:29:01','2009-08-11 20:02:29','http://photos-a.ak.fbcdn.net/photos-ak-snc1/v3345/77/120/504883639/n504883639_1620496_2311460.jpg','IMG_1108',NULL,NULL,'downloaded'),(447,26,'2168458717792032931',87,'2009-07-13 05:29:04','2009-08-11 20:02:47','http://photos-d.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1562787_215659.jpg','IMG_1042',NULL,NULL,'downloaded'),(464,27,'2168458717791299477',92,'2009-07-13 05:29:07','2009-08-11 20:03:17','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v335/77/120/504883639/n504883639_829333_4889.jpg','','--- \n- Tracy Ballard\n',NULL,'downloaded'),(488,31,'2168458717791919973',91,'2009-07-13 05:29:18','2009-08-11 20:03:11','http://photos-f.ak.fbcdn.net/hphotos-ak-snc1/hs022.snc1/2460_53152223639_504883639_1449829_6421260_n.jpg','IMG_0998',NULL,NULL,'downloaded'),(523,33,'2168458717791887195',89,'2009-07-13 05:29:24','2009-08-11 20:02:58','http://photos-d.ak.fbcdn.net/hphotos-ak-snc1/hs036.snc1/2416_51216108639_504883639_1417051_7712_n.jpg','016_16',NULL,NULL,'downloaded'),(572,35,'2168458717791887257',78,'2009-07-13 05:29:32','2009-08-11 20:01:52','http://photos-b.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1417113_1484.jpg','058_58',NULL,NULL,'downloaded'),(612,37,'2168458717791886840',67,'2009-07-13 05:29:39','2009-08-11 20:00:49','http://photos-a.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416696_5317.jpg','IMG_1428',NULL,NULL,'downloaded'),(616,37,'2168458717791886837',79,'2009-07-13 05:29:39','2009-08-11 20:02:00','http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v653/77/120/504883639/n504883639_1416693_9740.jpg','IMG_1434',NULL,NULL,'downloaded'),(624,38,'2168458717791886589',80,'2009-07-13 05:29:42','2009-08-11 20:02:05','http://photos-f.ak.fbcdn.net/photos-ak-snc1/v2416/77/120/504883639/n504883639_1416445_1133.jpg','IMG_0934','--- \n- Linda Nelle Edmond\n',NULL,'downloaded');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_sites`
--

LOCK TABLES `backup_sites` WRITE;
/*!40000 ALTER TABLE `backup_sites` DISABLE KEYS */;
INSERT INTO `backup_sites` VALUES (1,'facebook',NULL),(2,'twitter',NULL),(3,'gmail',NULL),(4,'blog',NULL),(5,'flickr',NULL);
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
  UNIQUE KEY `backup_job_source` (`backup_job_id`,`backup_source_id`),
  KEY `index_backup_source_jobs_on_backup_job_id` (`backup_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_source_jobs`
--

LOCK TABLES `backup_source_jobs` WRITE;
/*!40000 ALTER TABLE `backup_source_jobs` DISABLE KEYS */;
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
  KEY `index_backup_sources_on_user_id` (`user_id`),
  KEY `index_backup_sources_on_backup_site_id` (`backup_site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_sources`
--

LOCK TABLES `backup_sources` WRITE;
/*!40000 ALTER TABLE `backup_sources` DISABLE KEYS */;
INSERT INTO `backup_sources` VALUES (1,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,4,1,0,0,NULL,1,NULL,NULL),(7,'FeedUrl',NULL,NULL,'http://simian187.vox.com/library/posts/atom.xml',1,NULL,NULL,NULL,'2009-07-17 02:22:22','2009-07-17 02:22:22',2,4,0,0,NULL,1,NULL,NULL),(17,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'2009-07-17 19:35:30','2009-07-29 19:12:58',2,1,0,0,NULL,1,'2009-07-17 19:52:21','2009-07-17 19:52:21'),(18,'FeedUrl',NULL,NULL,'http://www.csmonitor.com/rss/top.rss',1,NULL,NULL,NULL,'2009-07-20 16:44:27','2009-07-20 16:44:27',2,4,0,0,NULL,1,NULL,NULL),(19,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'2009-07-22 18:14:55','2009-07-22 18:15:49',1,1,0,0,NULL,1,NULL,NULL),(23,'GmailAccount','Updatingas','ssss',NULL,1,'Login failed',NULL,NULL,'2009-07-29 18:44:02','2009-07-30 21:48:03',2,3,0,0,NULL,1,'2009-07-30 21:48:03','2009-07-29 18:44:02'),(24,'FeedUrl',NULL,NULL,'http://feeds.feedburner.com/railscasts',1,NULL,NULL,NULL,'2009-07-29 19:13:56','2009-07-29 19:13:56',2,4,0,0,NULL,1,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `backup_states`
--

LOCK TABLES `backup_states` WRITE;
/*!40000 ALTER TABLE `backup_states` DISABLE KEYS */;
INSERT INTO `backup_states` VALUES (1,'2009-07-17 02:08:12','2009-07-16 22:03:00','2009-07-17 02:08:12',1,NULL,'--- \n- Timed out\n','--- []\n\n',1,'2009-07-16 20:56:59','2009-07-22 18:23:17',22),(2,'2009-07-27 03:33:39','2009-07-29 09:12:48','2009-07-29 09:12:48',0,NULL,'--- \n- Timed out\n','--- []\n\n',2,'2009-07-16 21:05:30','2009-07-29 09:12:48',41);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Birth','2009-07-16 18:10:59','2009-07-16 18:10:59',1),(2,'Marriage','2009-07-16 18:10:59','2009-07-16 18:10:59',1),(3,'Children','2009-07-16 18:10:59','2009-07-16 18:10:59',1),(4,'Education','2009-07-16 18:10:59','2009-07-16 18:10:59',1),(5,'Career','2009-07-16 18:10:59','2009-07-16 18:10:59',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `circles`
--

LOCK TABLES `circles` WRITE;
/*!40000 ALTER TABLE `circles` DISABLE KEYS */;
INSERT INTO `circles` VALUES (1,'Spouse','2009-07-16 18:11:00','2009-07-16 18:11:00',0),(2,'Child','2009-07-16 18:11:00','2009-07-16 18:11:00',0),(3,'Parent','2009-07-16 18:11:00','2009-07-16 18:11:00',0),(4,'Friend','2009-07-16 18:11:00','2009-07-16 18:11:00',0),(5,'Sibling','2009-07-16 18:11:00','2009-07-16 18:11:00',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
INSERT INTO `contents` VALUES (67,42488,'Photo','N504883639 1416696 5317','n504883639_1416696_5317.jpg',NULL,NULL,453,604,'2009-08-11 20:00:49','2009-08-11 20:03:17',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1428',NULL,'processing',0,NULL),(68,53183,'Photo','5851 98712838639 504883639 2045788 6144862 N','5851_98712838639_504883639_2045788_6144862_n.jpg',NULL,NULL,604,453,'2009-08-11 20:00:54','2009-08-11 20:00:54',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1315',NULL,'staging',0,NULL),(69,36393,'Photo','3220 78327208639 504883639 1735478 584478 N','3220_78327208639_504883639_1735478_584478_n.jpg',NULL,NULL,483,604,'2009-08-11 20:00:58','2009-08-11 20:00:59',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'Azzura_Photography_Finals_3_resize',NULL,'staging',0,NULL),(70,54177,'Photo','5851 99591888639 504883639 2057987 8359997 N','5851_99591888639_504883639_2057987_8359997_n.jpg',NULL,NULL,604,453,'2009-08-11 20:01:04','2009-08-11 20:01:04',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2559',NULL,'staging',0,NULL),(71,68420,'Photo','N504883639 1620490 4511604','n504883639_1620490_4511604.jpg',NULL,NULL,604,453,'2009-08-11 20:01:11','2009-08-11 20:01:11',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1097',NULL,'staging',0,NULL),(72,52135,'Photo','5851 98715328639 504883639 2045841 515771 N','5851_98715328639_504883639_2045841_515771_n.jpg',NULL,NULL,604,453,'2009-08-11 20:01:16','2009-08-11 20:01:16',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2334',NULL,'staging',0,NULL),(73,58792,'Photo','N504883639 2023731 4398497','n504883639_2023731_4398497.jpg',NULL,NULL,604,453,'2009-08-11 20:01:22','2009-08-11 20:01:22',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1280',NULL,'staging',0,NULL),(74,52315,'Photo','5851 99592498639 504883639 2058004 5913409 N','5851_99592498639_504883639_2058004_5913409_n.jpg',NULL,NULL,604,453,'2009-08-11 20:01:27','2009-08-11 20:01:28',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2483',NULL,'staging',0,NULL),(75,52316,'Photo','4332 81109478639 504883639 1775446 390134 N','4332_81109478639_504883639_1775446_390134_n.jpg',NULL,NULL,453,604,'2009-08-11 20:01:32','2009-08-11 20:01:33',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1159',NULL,'staging',0,NULL),(76,66199,'Photo','N504883639 2023717 1569920','n504883639_2023717_1569920.jpg',NULL,NULL,604,453,'2009-08-11 20:01:39','2009-08-11 20:01:39',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1275',NULL,'staging',0,NULL),(77,89808,'Photo','N504883639 2047443 2729318','n504883639_2047443_2729318.jpg',NULL,NULL,604,453,'2009-08-11 20:01:47','2009-08-11 20:01:47',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2422',NULL,'staging',0,NULL),(78,51833,'Photo','N504883639 1417113 1484','n504883639_1417113_1484.jpg',NULL,NULL,453,604,'2009-08-11 20:01:52','2009-08-11 20:01:52',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'058_58',NULL,'staging',0,NULL),(79,81003,'Photo','N504883639 1416693 9740','n504883639_1416693_9740.jpg',NULL,NULL,453,604,'2009-08-11 20:02:00','2009-08-11 20:02:00',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1434',NULL,'staging',0,NULL),(80,54295,'Photo','N504883639 1416445 1133','n504883639_1416445_1133.jpg',NULL,NULL,604,453,'2009-08-11 20:02:05','2009-08-11 20:02:05',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_0934',NULL,'staging',0,NULL),(81,48851,'Photo','5851 98715593639 504883639 2045849 4000641 N','5851_98715593639_504883639_2045849_4000641_n.jpg',NULL,NULL,453,604,'2009-08-11 20:02:10','2009-08-11 20:02:10',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2347',NULL,'staging',0,NULL),(82,58877,'Photo','5851 98715413639 504883639 2045844 1925682 N','5851_98715413639_504883639_2045844_1925682_n.jpg',NULL,NULL,604,453,'2009-08-11 20:02:16','2009-08-11 20:02:16',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2337',NULL,'staging',0,NULL),(83,65835,'Photo','5851 99592608639 504883639 2058008 1604007 N','5851_99592608639_504883639_2058008_1604007_n.jpg',NULL,NULL,604,453,'2009-08-11 20:02:22','2009-08-11 20:02:22',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_2487',NULL,'staging',0,NULL),(84,70872,'Photo','N504883639 1620496 2311460','n504883639_1620496_2311460.jpg',NULL,NULL,604,453,'2009-08-11 20:02:28','2009-08-11 20:02:28',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1108',NULL,'staging',0,NULL),(85,55963,'Photo','5851 99591798639 504883639 2057982 4276738 N','5851_99591798639_504883639_2057982_4276738_n.jpg',NULL,NULL,453,604,'2009-08-11 20:02:34','2009-08-11 20:02:34',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1394',NULL,'staging',0,NULL),(86,62489,'Photo','5851 99591718639 504883639 2057977 4284778 N','5851_99591718639_504883639_2057977_4284778_n.jpg',NULL,NULL,604,453,'2009-08-11 20:02:42','2009-08-11 20:02:43',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1389',NULL,'staging',0,NULL),(87,30936,'Photo','N504883639 1562787 215659','n504883639_1562787_215659.jpg',NULL,NULL,430,604,'2009-08-11 20:02:47','2009-08-11 20:02:47',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1042',NULL,'staging',0,NULL),(88,42025,'Photo','N504883639 1620481 5681139','n504883639_1620481_5681139.jpg',NULL,NULL,604,453,'2009-08-11 20:02:52','2009-08-11 20:02:52',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_1070',NULL,'staging',0,NULL),(89,43213,'Photo','2416 51216108639 504883639 1417051 7712 N','2416_51216108639_504883639_1417051_7712_n.jpg',NULL,NULL,604,453,'2009-08-11 20:02:57','2009-08-11 20:02:58',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'016_16',NULL,'staging',0,NULL),(90,49018,'Photo','N504883639 783676 6712','n504883639_783676_6712.jpg',NULL,NULL,448,604,'2009-08-11 20:03:04','2009-08-11 20:03:04',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'',NULL,'staging',0,NULL),(91,63909,'Photo','2460 53152223639 504883639 1449829 6421260 N','2460_53152223639_504883639_1449829_6421260_n.jpg',NULL,NULL,604,453,'2009-08-11 20:03:11','2009-08-11 20:03:11',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'IMG_0998',NULL,'staging',0,NULL),(92,49406,'Photo','N504883639 829333 4889','n504883639_829333_4889.jpg',NULL,NULL,604,453,'2009-08-11 20:03:17','2009-08-11 20:03:17',4,'image/jpeg',NULL,NULL,NULL,NULL,NULL,'',NULL,'staging',0,NULL);
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
-- Table structure for table `dev_staging_maps`
--

DROP TABLE IF EXISTS `dev_staging_maps`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `dev_staging_maps` (
  `id` int(11) NOT NULL auto_increment,
  `dev_user_id` int(11) NOT NULL,
  `staging_user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `dev_staging_maps`
--

LOCK TABLES `dev_staging_maps` WRITE;
/*!40000 ALTER TABLE `dev_staging_maps` DISABLE KEYS */;
INSERT INTO `dev_staging_maps` VALUES (1,2,34),(2,2,34);
/*!40000 ALTER TABLE `dev_staging_maps` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `facebook_contents`
--

LOCK TABLES `facebook_contents` WRITE;
/*!40000 ALTER TABLE `facebook_contents` DISABLE KEYS */;
INSERT INTO `facebook_contents` VALUES (1,1,'--- \n- Thomas James\n- Daniel Lydiard\n- Adam MacBeth\n- Cassie Wallender\n- Tony Wright\n- Asha Sophia\n- Sean Jordan\n- Laura McNamara\n- Michelle Lecompte\n- Bullet Mehta\n- Jesse Driskill\n- Andrew Hermitage\n- Ernst Gmeiner\n- Marie Burns Garman\n- Marija Zmiarovich\n- Christina Todd Mallet\n- Kindra Howard Orsenigo\n- Jim DeLeskie\n- Federico Vieto\n- Brent Dreyer\n- Kelly Smith\n- Jorim R Gray\n- Diane Devine\n- Jeff Terrell\n- Jeff Patterson\n- Molly Meggyesy\n- Terri Esterly Pollard\n- Erin Zane Levin\n- David M. Baker\n- Nikolas Leyde\n- Chononita Fabian Piorkowsky\n- Lydia Ranger Richman\n- Tony Taylor\n- Josh Rebel\n- Thomas Kim\n- Rachel McLennan\n- Tim Gerber\n- Aron Higgins\n- William Velimir Pavichevich\n- Greg P. Smith\n- Eric Rogers\n- Randy Turner\n- Brandon Bozzi\n- Darn It\n- John Cornelison\n- Emily Stogsdill\n- Charlo Barbosa\n- Frederick Woodruff\n- Jacque Garite Krum\n- Aexis Liester\n- Rosemary Luellen Geelan\n- Anthony Valenzuela\n- Elph Stone\n- Janna Ignatow\n- Lisa Kristensen\n- Bryce Gifford\n- Keith Boudreau\n- Chris Terp\n- Scott Golembiewski\n- Brittany Nicole Owensby\n- Pamn Aspiri\n- Ian Eisenberg\n- Robert Williams\n- Mark Madsen\n- Rizki Arnosa\n- Tara Brook\n- Benetton Fe.\n- Dushan Pavichevich\n- Angie Moore\n- Kirrilee Jacobi\n- Marc Mauger\n- John E. Skidmore\n- Heidi Bentz\n- Jeff Davidson\n- Asa Williams\n- Darryl Caldwell\n- Shawn Reinas\n- Michelle Eikrem\n- Teresa Savage\n- Shirley Vivion\n- Trevor Edmond\n- Nicole Zaferes Gustad\n- Heidi Carpenter\n- Greg Garite\n- Curt Alan Enos\n- Mike Fink\n- Lisa Nourse\n- Matt Wilson\n- Tony Gerber\n- Nicholas Black\n- Will Cronk\n- Wendy Cafferky Niles\n- Kristie Spilios\n- Ryan Edmond\n- Steve Sowers\n- Robin Schauer\n- Thom Jenkins\n- Silas J. Warner\n- Michael Wong\n- George Skip Ekins\n- Jeffrey Lloyd Snader\n- Seth Warner\n- Red Bike\n- Phil Moyer\n- Zachary Lark\n- Jennifer Robbins Curtis\n- Nickolaus Smith\n- Stephanie Patrick Richardson\n- Risa Roberts Warner\n- Eric Freund\n- Work Truck Malt Liquor\n- Krista Martin Foust\n- Feby Artandi\n- Niki Green\n- Hendra Nicholas\n- Doug Boudreau\n- Hoby Van Hoose\n- Rebecca O\'Connor\n- Kassi Osterholtz\n- Anna Kinsler\n- Amy Glamser\n- Jennifer Eikrem\n- Sam Templeton\n- Brodie Carroll\n- Troy Brocato\n- Dawn Hunter\n- Deidra Johnson\n- Lois Hall Preisendorf\n- Erin Rollins Pletsch\n- Janie Spencer\n- Steve Chadwick\n- Erica Legum\n- Jennifer Gillette\n- Gregory J Geelan\n- Keenan Warner\n- Jamie Warter\n- Colton La Zar\n- Kindel Glamser\n- Steven Ohmert\n- Scott Garite\n- Sarah Hood\n- Linda Nelle Edmond\n- Michael Kunjara\n- Pedro Margate\n- Amanda Dunker\n- Serena A. Warner\n- Sonny Julian\n- Simon Hedley\n','--- \n- Geography\n- Common Interest\n- Entertainment &amp; Arts\n- Internet &amp; Technology\n- Business\n- Music\n- Common Interest\n- Business\n- Common Interest\n- Geography\n- Common Interest\n- Just for Fun\n- Common Interest\n- Just for Fun\n- Entertainment &amp; Arts\n- Common Interest\n- Common Interest\n- Common Interest\n- Common Interest\n- Student Groups\n- Geography\n- Business\n- Organizations\n- Geography\n- Entertainment &amp; Arts\n- Organizations\n- Sports &amp; Recreation\n- Internet &amp; Technology\n- Internet &amp; Technology\n- Business\n- Common Interest\n- Common Interest\n','2009-07-13 05:27:36','2009-07-17 02:05:57'),(2,2,'--- \n- Kimberley Mauger\n- Andrew Edmond\n- Giselle Young Phillips\n- Atle Veka\n- Jennifer Cain\n- Ruth Hampton\n- Kelly Kampen\n- Nicole Miller\n- Justin Mauger\n- Julia Cain\n- Jamie Strube\n- Eric Rogers\n- Joseph Carver\n- Charlo Barbosa\n- Olive Knaus\n- Paul Riley\n- Ian Eisenberg\n- Sarah Greenwood\n- Arthur Apple Clawson\n- Colleen Flynn\n- Mike Cain\n- Leah Gerrard\n- Joshua Sklaroff\n- Quinn Posner\n- Julie Gerrard\n- Chris Kobayashi\n- Nils Dickmann\n- Eon D. Preservation\n','--- []\n\n','2009-07-17 19:52:23','2009-07-17 19:52:23');
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
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `feed_guid` (`feed_id`,`guid`),
  KEY `index_feed_entries_on_guid` (`guid`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `feed_entries`
--

LOCK TABLES `feed_entries` WRITE;
/*!40000 ALTER TABLE `feed_entries` DISABLE KEYS */;
INSERT INTO `feed_entries` VALUES (1,1,'simian187','Create Ruby gem',NULL,'\n            \n                \n         http://railscasts.com/episodes/135-making-a-gem     \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- \n- ruby\n- gems\n','http://simian187.vox.com/library/post/create-ruby-gem.html?_c=feed-atom','2009-07-06 00:35:31','tag:vox.com,2009-07-06:asset-6a00fad6b065fb00050110166e15c2860c',NULL),(2,1,'simian187','1st Github fork',NULL,'\n            \n                \n         http://github.com/simianarmy/feedzirra/tree   Patched some code that raised exception.  Nice way to learn how to fork a Ruby gem/plugin and push back changes.   Now I need to make it a gem and push the change so I can download it from githhub for ...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- \n- ruby\n- github\n','http://simian187.vox.com/library/post/1st-github-fork.html?_c=feed-atom','2009-07-06 00:15:07','tag:vox.com,2009-07-06:asset-6a00fad6b065fb0005011018488418860f',NULL),(3,1,'simian187','Git + Ruby links',NULL,'\n            \n                \n         Forking project on Github: http://github.com/guides/fork-a-project-and-submit-your-modifications   Using github-gem:  Let\'s say you just forked `github-gem` on GitHub from defunkt.   $ github clone YOU/github-gem $ cd github-gem $ github pull defu...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- \n- ruby\n- rails\n- git\n','http://simian187.vox.com/library/post/git-links.html?_c=feed-atom','2009-07-05 23:54:49','tag:vox.com,2009-07-05:asset-6a00fad6b065fb00050110166e129f860c',NULL),(4,1,'simian187','On Blade',NULL,'\n            \n                \n         From funny as shit IOZ:   \" If we as a country and I as a man are able to accord millions of dollars in box office revenue to the spectacle of Wesley Snipes and Kris fucking Kristofferson duking it out with Stephen Dorff and Udo holyshit Kier whil...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- []\n\n','http://simian187.vox.com/library/post/on-blade.html?_c=feed-atom','2009-07-01 01:20:57','tag:vox.com,2009-07-01:asset-6a00fad6b065fb0005011016a5961e860d',NULL),(5,1,'simian187','Funny sad true',NULL,'\n            \n                \n          \"And a note about costs: Sometimes, my fellow Americans, we really suck.  A few trillion (more actually) to kill a bunch of foreigners in a couple of wars that have yielded almost nothing but instability and suffering?  It would be unpatriotic to...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- []\n\n','http://simian187.vox.com/library/post/funny-sad-true.html?_c=feed-atom','2009-06-23 18:52:41','tag:vox.com,2009-06-23:asset-6a00fad6b065fb0005011017e0f35b860e',NULL),(6,1,'simian187','Solipsism',NULL,'\n            \n                \n         \"No matter who you are, or where you live on this planet, you can be sure that no matter what you\'re going through, pundits in America will feel your pain, know your hope, look at you, and see exactly what\'s most important: themselves.\"   DearLeader    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- []\n\n','http://simian187.vox.com/library/post/solipsism.html?_c=feed-atom','2009-06-18 19:42:33','tag:vox.com,2009-06-18:asset-6a00fad6b065fb00050110169ceebd860d',NULL),(7,1,'simian187','Guidelines for torture impunity',NULL,'\n            \n                \n          1. Blame the supposed \"bad apples.\" 2. Invoke the security argument. (\"It protected us.\") 3. Appeal to national unity. (\"We need to move forward together.\")     \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- []\n\n','http://simian187.vox.com/library/post/guidelines-for-torture-impunity.html?_c=feed-atom','2009-06-11 14:26:06','tag:vox.com,2009-06-11:asset-6a00fad6b065fb00050110169623e2860d',NULL),(8,1,'simian187','Terminator &amp; Drones',NULL,'\n            \n                \n          \"While I am not especially concerned that the destabilization of this corner of the world will result in some Tom, Dick, or Mohammed detonating a nuke in the new, pedestrian-friendly Times Square, I nevertheless think it must be awfully shitty to...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- []\n\n','http://simian187.vox.com/library/post/terminator-drones.html?_c=feed-atom','2009-06-02 22:07:15','tag:vox.com,2009-06-02:asset-6a00fad6b065fb00050110160ff5a2860b',NULL),(9,1,'simian187','Suspenders: Rails project template',NULL,'\n            \n                \n         http://github.com/thoughtbot/suspenders/tree/master   A Rails project template, intended to keep app baselines up to date. Includes shoulda, mocha, factory_girl, Hoptoad, git rake tasks, cap recipes, etc.    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- \n- programming\n- rails\n','http://simian187.vox.com/library/post/suspenders-rails-project-template.html?_c=feed-atom','2009-05-30 17:58:17','tag:vox.com,2009-05-30:asset-6a00fad6b065fb00050110182e0291860f',NULL),(10,1,'simian187','fbi &amp; stupid terrah-rists',NULL,'\n            \n                \n          On the latest dastardly thought-crime perpetrated by some inbred racist domestic terrarists in NYC:   \"Terrorism has long been the charge that repressive governments have wielded firstly against their political enemies and secondly against all so...    \n    Read and post comments   |   \n    Send to a friend \n\n\n                \n            \n        ',NULL,'--- \n- terrorism\n','http://simian187.vox.com/library/post/terrah-rizm.html?_c=feed-atom','2009-05-22 14:33:26','tag:vox.com,2009-05-22:asset-6a00fad6b065fb0005011017c9e6ae860e',NULL);
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
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_feeds_on_backup_source_id` (`backup_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `feeds`
--

LOCK TABLES `feeds` WRITE;
/*!40000 ALTER TABLE `feeds` DISABLE KEYS */;
INSERT INTO `feeds` VALUES (1,7,'simian187&#x2019;s blog','http://simian187.vox.com/library/posts/page/1/','http://simian187.vox.com/library/posts/atom.xml',NULL,'2009-07-06 03:33:27',NULL),(2,18,'Christian Science Monitor | Top Stories','http://csmonitor.com','http://www.csmonitor.com/rss/top.rss','\"b1c-43d1c200\"','2009-07-17 20:02:16',NULL),(3,24,'Railscasts','http://railscasts.com','http://feeds.feedburner.com/railscasts','t2IefX+hNzypW4RzlkOXQNRXrMQ','2009-07-29 19:13:54','2009-07-29 19:13:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,2,'asstown','sucker','asshole','2009-01-01',NULL,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `photo_thumbnails`
--

LOCK TABLES `photo_thumbnails` WRITE;
/*!40000 ALTER TABLE `photo_thumbnails` DISABLE KEYS */;
INSERT INTO `photo_thumbnails` VALUES (3,1,'image/jpeg','n504883639_2023717_1569920_thumb.jpg','thumb',66199,100,75,'2009-08-11 18:47:11','2009-08-11 18:47:11'),(4,53,'image/jpeg','n504883639_1416696_5317_thumb.jpg','thumb',42488,75,100,'2009-08-11 18:59:24','2009-08-11 18:59:24'),(5,54,'image/jpeg','2460_53152223639_504883639_1449829_6421260_n_thumb.jpg','thumb',63909,100,75,'2009-08-11 18:59:30','2009-08-11 18:59:30'),(6,55,'image/jpeg','5851_98715328639_504883639_2045841_515771_n_thumb.jpg','thumb',52135,100,75,'2009-08-11 18:59:36','2009-08-11 18:59:36'),(7,56,'image/jpeg','n504883639_2023717_1569920_thumb.jpg','thumb',66199,100,75,'2009-08-11 18:59:43','2009-08-11 18:59:43'),(8,57,'image/jpeg','n504883639_1416445_1133_thumb.jpg','thumb',54295,100,75,'2009-08-11 18:59:48','2009-08-11 18:59:48'),(9,58,'image/jpeg','n504883639_2023731_4398497_thumb.jpg','thumb',58792,100,75,'2009-08-11 18:59:54','2009-08-11 18:59:54'),(10,59,'image/jpeg','n504883639_829333_4889_thumb.jpg','thumb',49406,100,75,'2009-08-11 18:59:59','2009-08-11 18:59:59'),(11,60,'image/jpeg','5851_99591798639_504883639_2057982_4276738_n_thumb.jpg','thumb',55963,75,100,'2009-08-11 19:00:05','2009-08-11 19:00:05'),(12,61,'image/jpeg','n504883639_1620496_2311460_thumb.jpg','thumb',70872,100,75,'2009-08-11 19:00:12','2009-08-11 19:00:12'),(13,62,'image/jpeg','5851_98712838639_504883639_2045788_6144862_n_thumb.jpg','thumb',53183,100,75,'2009-08-11 19:00:18','2009-08-11 19:00:18'),(14,63,'image/jpeg','n504883639_1562787_215659_thumb.jpg','thumb',30936,71,100,'2009-08-11 19:00:22','2009-08-11 19:00:22'),(15,64,'image/jpeg','n504883639_1620481_5681139_thumb.jpg','thumb',42025,100,75,'2009-08-11 19:00:27','2009-08-11 19:00:27'),(16,65,'image/jpeg','n504883639_1417113_1484_thumb.jpg','thumb',51833,75,100,'2009-08-11 19:00:33','2009-08-11 19:00:33'),(17,66,'image/jpeg','5851_99591718639_504883639_2057977_4284778_n_thumb.jpg','thumb',62489,100,75,'2009-08-11 19:00:40','2009-08-11 19:00:40'),(18,67,'image/jpeg','n504883639_1416696_5317_thumb.jpg','thumb',42488,75,100,'2009-08-11 20:00:49','2009-08-11 20:00:49'),(19,68,'image/jpeg','5851_98712838639_504883639_2045788_6144862_n_thumb.jpg','thumb',53183,100,75,'2009-08-11 20:00:54','2009-08-11 20:00:54'),(20,69,'image/jpeg','3220_78327208639_504883639_1735478_584478_n_thumb.jpg','thumb',36393,80,100,'2009-08-11 20:00:58','2009-08-11 20:00:58'),(21,70,'image/jpeg','5851_99591888639_504883639_2057987_8359997_n_thumb.jpg','thumb',54177,100,75,'2009-08-11 20:01:04','2009-08-11 20:01:04'),(22,71,'image/jpeg','n504883639_1620490_4511604_thumb.jpg','thumb',68420,100,75,'2009-08-11 20:01:11','2009-08-11 20:01:11'),(23,72,'image/jpeg','5851_98715328639_504883639_2045841_515771_n_thumb.jpg','thumb',52135,100,75,'2009-08-11 20:01:16','2009-08-11 20:01:16'),(24,73,'image/jpeg','n504883639_2023731_4398497_thumb.jpg','thumb',58792,100,75,'2009-08-11 20:01:22','2009-08-11 20:01:22'),(25,74,'image/jpeg','5851_99592498639_504883639_2058004_5913409_n_thumb.jpg','thumb',52315,100,75,'2009-08-11 20:01:27','2009-08-11 20:01:27'),(26,75,'image/jpeg','4332_81109478639_504883639_1775446_390134_n_thumb.jpg','thumb',52316,75,100,'2009-08-11 20:01:33','2009-08-11 20:01:33'),(27,76,'image/jpeg','n504883639_2023717_1569920_thumb.jpg','thumb',66199,100,75,'2009-08-11 20:01:39','2009-08-11 20:01:39'),(28,77,'image/jpeg','n504883639_2047443_2729318_thumb.jpg','thumb',89808,100,75,'2009-08-11 20:01:47','2009-08-11 20:01:47'),(29,78,'image/jpeg','n504883639_1417113_1484_thumb.jpg','thumb',51833,75,100,'2009-08-11 20:01:52','2009-08-11 20:01:52'),(30,79,'image/jpeg','n504883639_1416693_9740_thumb.jpg','thumb',81003,75,100,'2009-08-11 20:02:00','2009-08-11 20:02:00'),(31,80,'image/jpeg','n504883639_1416445_1133_thumb.jpg','thumb',54295,100,75,'2009-08-11 20:02:05','2009-08-11 20:02:05'),(32,81,'image/jpeg','5851_98715593639_504883639_2045849_4000641_n_thumb.jpg','thumb',48851,75,100,'2009-08-11 20:02:10','2009-08-11 20:02:10'),(33,82,'image/jpeg','5851_98715413639_504883639_2045844_1925682_n_thumb.jpg','thumb',58877,100,75,'2009-08-11 20:02:16','2009-08-11 20:02:16'),(34,83,'image/jpeg','5851_99592608639_504883639_2058008_1604007_n_thumb.jpg','thumb',65835,100,75,'2009-08-11 20:02:22','2009-08-11 20:02:22'),(35,84,'image/jpeg','n504883639_1620496_2311460_thumb.jpg','thumb',70872,100,75,'2009-08-11 20:02:28','2009-08-11 20:02:28'),(36,85,'image/jpeg','5851_99591798639_504883639_2057982_4276738_n_thumb.jpg','thumb',55963,75,100,'2009-08-11 20:02:34','2009-08-11 20:02:34'),(37,86,'image/jpeg','5851_99591718639_504883639_2057977_4284778_n_thumb.jpg','thumb',62489,100,75,'2009-08-11 20:02:43','2009-08-11 20:02:43'),(38,87,'image/jpeg','n504883639_1562787_215659_thumb.jpg','thumb',30936,71,100,'2009-08-11 20:02:47','2009-08-11 20:02:47'),(39,88,'image/jpeg','n504883639_1620481_5681139_thumb.jpg','thumb',42025,100,75,'2009-08-11 20:02:52','2009-08-11 20:02:52'),(40,89,'image/jpeg','2416_51216108639_504883639_1417051_7712_n_thumb.jpg','thumb',43213,100,75,'2009-08-11 20:02:57','2009-08-11 20:02:57'),(41,90,'image/jpeg','n504883639_783676_6712_thumb.jpg','thumb',49018,74,100,'2009-08-11 20:03:04','2009-08-11 20:03:04'),(42,91,'image/jpeg','2460_53152223639_504883639_1449829_6421260_n_thumb.jpg','thumb',63909,100,75,'2009-08-11 20:03:11','2009-08-11 20:03:11'),(43,92,'image/jpeg','n504883639_829333_4889_thumb.jpg','thumb',49406,100,75,'2009-08-11 20:03:17','2009-08-11 20:03:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-13 05:27:33','2009-07-17 02:05:56','--- \n:books: Wheel Of Time\n:sex: male\n:tv: \"\"\n:pic_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=86bcafc985b603fb8882af90370286e6&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fs504883639_8563.jpg&amp;v=5\n:birthday: June 22, 1973\n:has_added_app: \"1\"\n:about_me: \"\"\n:timezone: \"-7\"\n:pic_small: http://profile.ak.fbcdn.net/v230/1085/109/t504883639_8563.jpg\n:affiliations: \n- !ruby/object:Facebooker::Affiliation \n  name: Seattle, WA\n  nid: \"67108883\"\n  populated: true\n  status: \"\"\n  type: region\n  year: \"0\"\n:religion: Spiritual but not religious\n:profile_update_time: \"0\"\n:pic_big_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=d535f7591dabe7f236ac9d739680046f&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fn504883639_8563.jpg&amp;v=5\n:last_name: Edmond\n:first_name: Andrew\n:pic_big: http://profile.ak.fbcdn.net/v230/1085/109/n504883639_8563.jpg\n:wall_count: \"64\"\n:profile_url: http://www.facebook.com/nerolabs\n:notes_count: \n:meeting_sex: \n- female\n:pic_small_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=3f918ff7bc167e5c80cd33dafe2c5165&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Ft504883639_8563.jpg&amp;v=5\n:meeting_for: \n- Friendship\n- Networking\n:significant_other_id: \n:political: Libertarian\n:proxied_email: apps+109701370954.504883639.ac7a5eda699ebc4478f6455ac41b40a0@proxymail.facebook.com\n:locale: en_US\n:activities: \"\"\n:hs_info: !ruby/object:Facebooker::EducationInfo::HighschoolInfo \n  grad_year: \"1991\"\n  hs1_id: \"2272\"\n  hs1_name: William S. Hart Senior High\n  hs2_id: \"0\"\n  hs2_name: {}\n\n  populated: true\n:pic_square_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=1122252be1b7b8da6833a8b1d616c545&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv230%2F1085%2F109%2Fq504883639_8563.jpg&amp;v=5\n:interests: \"\"\n:music: \"\"\n:quotes: \"\"\n:email_hashes: []\n\n:movies: The Thing (1982), Godfather, The Notebook, Across the Universe, Fight Club\n:relationship_status: In a Relationship\n:name: Andrew Edmond\n:current_location: \n:pic_square: http://profile.ak.fbcdn.net/v230/1085/109/q504883639_8563.jpg\n:work_history: \n- !ruby/object:Facebooker::WorkInfo \n  company_name: Andrew Edmond Consulting\n  description: \"\"\n  end_date: \"\"\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: Managing Partner\n  start_date: 0000-00\n- !ruby/object:Facebooker::WorkInfo \n  company_name: GridNetworks, Inc\n  description: \"\"\n  end_date: 2007-12\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: Chief Architect\n  start_date: 2004-12\n- !ruby/object:Facebooker::WorkInfo \n  company_name: Accretive Technologies Inc.\n  description: \"\"\n  end_date: 2001-04\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: CEO\n  start_date: 1997-06\n:is_app_user: \"1\"\n:allowed_restrictions: alcohol\n:pic: http://profile.ak.fbcdn.net/v230/1085/109/s504883639_8563.jpg\n:education_history: \n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - Computer Science\n  degree: \"\"\n  name: University of Southern California\n  populated: true\n  year: \"1993\"\n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - Botany\n  degree: \"\"\n  name: University of Wyoming\n  populated: true\n  year: \"1997\"\n:hometown_location: !ruby/object:Facebooker::Location \n  city: Valencia\n  country: United States\n  populated: true\n  state: California\n  zip: {}\n\n'),(2,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-16 18:11:42','2009-07-17 19:52:22','--- \n:pic_square_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=36f61512a3e592a133aeecd2ea8bf1e1&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv229%2F946%2F113%2Fq1005737378_3584.jpg&amp;v=5\n:interests: \"\"\n:music: \"\"\n:quotes: \"\"\n:email_hashes: []\n\n:movies: Manos Hand of Fate\n:relationship_status: \"\"\n:current_location: \n:pic_square: http://profile.ak.fbcdn.net/v229/946/113/q1005737378_3584.jpg\n:work_history: \n- !ruby/object:Facebooker::WorkInfo \n  company_name: Me\n  description: I drink my own milkshake\n  end_date: \"\"\n  location: !ruby/object:Facebooker::Location \n    city: {}\n\n    country: {}\n\n    populated: true\n    state: {}\n\n  populated: true\n  position: CETFO\n  start_date: 2003-01\n:is_app_user: \"1\"\n:allowed_restrictions: alcohol\n:pic: http://profile.ak.fbcdn.net/v229/946/113/s1005737378_3584.jpg\n:education_history: \n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - Computer Science\n  degree: \"\"\n  name: University of Washington\n  populated: true\n  year: \"2010\"\n- !ruby/object:Facebooker::EducationInfo \n  concentrations: \n  - I forget\n  degree: \"\"\n  name: University of Oregon\n  populated: true\n  year: \"1995\"\n:hometown_location: !ruby/object:Facebooker::Location \n  city: Bellevue\n  country: United States\n  populated: true\n  state: Washington\n  zip: {}\n\n:books: \"\"\n:sex: male\n:tv: |-\n  Battlestar Galactica\n  Adult Swim\n  The Wire\n:pic_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=37729eb9f4d33e7d4a55ed52a65d198e&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv229%2F946%2F113%2Fs1005737378_3584.jpg&amp;v=5\n:birthday: May 11, 1974\n:has_added_app: \"1\"\n:about_me: \"\"\n:timezone: \"-7\"\n:pic_small: http://profile.ak.fbcdn.net/v229/946/113/t1005737378_3584.jpg\n:affiliations: []\n\n:religion: \"\"\n:profile_update_time: \"0\"\n:pic_big_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=295994a21c654a710e2f08866ea3320f&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv229%2F946%2F113%2Fn1005737378_3584.jpg&amp;v=5\n:last_name: Mauger\n:first_name: Marc\n:pic_big: http://profile.ak.fbcdn.net/v229/946/113/n1005737378_3584.jpg\n:wall_count: \"9\"\n:profile_url: http://www.facebook.com/simian\n:notes_count: \"1\"\n:meeting_sex: []\n\n:name: Marc Mauger\n:pic_small_with_logo: http://external.ak.fbcdn.net/safe_image.php?logo&amp;d=a53bdb6a2928cb85775e2e4a6204a803&amp;url=http%3A%2F%2Fprofile.ak.fbcdn.net%2Fv229%2F946%2F113%2Ft1005737378_3584.jpg&amp;v=5\n:meeting_for: []\n\n:significant_other_id: \"\"\n:political: Arch-conservative Federalist Santa Clause Party\n:proxied_email: apps+109701370954.1005737378.fa072522aec7e39a906e1245ddf46891@proxymail.facebook.com\n:locale: en_US\n:activities: \"\"\n:hs_info: !ruby/object:Facebooker::EducationInfo::HighschoolInfo \n  grad_year: \"1992\"\n  hs1_id: \"7022\"\n  hs1_name: Bellevue High School\n  hs2_id: \"0\"\n  hs2_name: {}\n\n  populated: true\n'),(3,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-27 17:09:38','2009-07-27 17:09:38',NULL),(4,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-07-28 23:32:33','2009-07-28 23:32:33',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Account',1,'2009-07-16 18:10:59','2009-07-16 18:10:59'),(2,'admin','Account',2,'2009-07-16 18:11:34','2009-07-16 18:11:34'),(3,'admin','Account',3,'2009-07-27 17:09:37','2009-07-27 17:09:37'),(4,'admin','Account',4,'2009-07-28 23:32:32','2009-07-28 23:32:32');
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
INSERT INTO `roles_users` VALUES (2,2,'2009-07-16 18:11:34','2009-07-16 18:11:34'),(3,3,'2009-07-27 17:09:37','2009-07-27 17:09:37'),(4,4,'2009-07-28 23:32:32','2009-07-28 23:32:32');
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
INSERT INTO `schema_migrations` VALUES ('20090624162633');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (1,'ed10f3772fc408ba51ae09061445c93b','BAh7CyIVdXNlcl9jcmVkZW50aWFscyIBgDA1NzQ0ZTUxNzgyYjU2MTdkNWJk\nNzUyZmNkZjNhZGI1ZmE3YjU2NjMzMzgyZWU2ZDg0ODg5MGU5MDUyNDBkZGVi\nZTcwN2I4MWUyMzk4MDk5OTQyNGYyMzBlNjU5NTNhYjU5Njg2YjAxYjcwZWI4\nOTE5MjE1ODY0MTllMzJmMWZiOg5yZXR1cm5fdG8iFS90aW1lbGluZXMvZGVi\ndWc6FWZhY2Vib29rX3Nlc3Npb25VOhhGYWNlYm9va2VyOjpTZXNzaW9uWwwi\nOzMuZlZraUN1RWJGdVhIdlNfZXJqT251Z19fLjg2NDAwLjEyNDc5NDAwMDAt\nMTAwNTczNzM3OGkEolXyO2wrB6ANYkoiHVVkT2s5X3dwOHRhZXF1X2FFa0M3\ndVFfXzAiJWY5NDcyZDUzMDAxNWMzMTU5ODI4ZjBlZjdjOGI2ZDAzIiUzMDRm\nNDFkMmNiZjRjYzZjMzY2N2JkMTI1ODgwMGVmOSIKZmxhc2hJQzonQWN0aW9u\nQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7ACIYdXNl\ncl9jcmVkZW50aWFsc19pZGkHOhRyZWNhcHRjaGFfZXJyb3Iw\n','2009-07-16 18:09:24','2009-07-18 01:30:39'),(2,'4ec2da701c63c6c2c945b7e28aef832b','BAh7DDoRb3JpZ2luYWxfdXJpMDoOcmV0dXJuX3RvIhEvbWVtYmVyX2hvbWUi\nFXVzZXJfY3JlZGVudGlhbHMiAYBkZTU3NzE2NTllZmM4M2E1NjI1OTIwMTlj\nYTM2MTIxYTc2M2YwYjNiOTY3ZmEyZDlhMGZhZWM1MmE2MDUxOGExMjgwOTNi\nM2E0OTQ3MjUyMjI4ODVjYzEwMDViNGMxNTAyNzcwMWI0NDU1ZTY2MWFmZjVk\nNjlkNzhhYjJlM2Y0NzoUcmVjYXB0Y2hhX2Vycm9yMDoVZmFjZWJvb2tfc2Vz\nc2lvblU6GEZhY2Vib29rZXI6OlNlc3Npb25bDCI7My52YzNmTXNQWF96cUh5\nNXVIVVhYVWF3X18uODY0MDAuMTI0ODkzMDAwMC0xMDA1NzM3Mzc4aQSiVfI7\nbCsH0ChxSiIdNlV1S3pZUlZ0ZERDUE1PaklvRkVHUV9fMCIlZjk0NzJkNTMw\nMDE1YzMxNTk4MjhmMGVmN2M4YjZkMDMiJTMwNGY0MWQyY2JmNGNjNmMzNjY3\nYmQxMjU4ODAwZWY5IgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFz\naDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsAIhh1c2VyX2NyZWRlbnRpYWxzX2lk\naQk=\n','2009-07-20 16:40:05','2009-07-29 21:15:09'),(3,'725e701b0992f2444c3becad7bb066ec','BAh7DCIVdXNlcl9jcmVkZW50aWFsczAiHWZpdmVydW5zX3R1bmV1cF9sYXN0\nX3VyaSIoaHR0cHM6Ly9kZXYuZXRlcm5vcy5jb20vc2lnbnVwL0ZyZWU6DnJl\ndHVybl90byIRL21lbWJlcl9ob21lOhFvcmlnaW5hbF91cmkwOhVmYWNlYm9v\na19zZXNzaW9uVToYRmFjZWJvb2tlcjo6U2Vzc2lvblsMIjszLm8xNlFpa0Nt\na3dBYzRlZURvNVRydlFfXy44NjQwMC4xMjUwMDMxNjAwLTEwMDU3MzczNzhp\nBKJV8jtsKwfw94FKIh10S0JITFlHZFozeElJRlNEYmRTOGJRX18wIiVmOTQ3\nMmQ1MzAwMTVjMzE1OTgyOGYwZWY3YzhiNmQwMyIlMzA0ZjQxZDJjYmY0Y2M2\nYzM2NjdiZDEyNTg4MDBlZjkiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6\nOkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewAiGHVzZXJfY3JlZGVudGlh\nbHNfaWQw\n','2009-07-31 06:09:22','2009-08-11 21:48:08'),(4,'4eb4fd128f8417960b28bdf64acc0cb2','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-08-03 08:10:55','2009-08-03 08:10:55'),(5,'4059d3fbd532cbd603390dbf5a1d0717','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2009-08-07 16:07:41','2009-08-07 16:07:41'),(6,'4d277c1f34072345384aab74e20dbeb2','BAh7CDoRb3JpZ2luYWxfdXJpIhcvYmFja3VwX3NvdXJjZXMuanM6DnJldHVy\nbl90b0AGIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6Rmxh\nc2hIYXNoewY6C25vdGljZSIuWW91IG11c3QgYmUgbG9nZ2VkIGluIHRvIGFj\nY2VzcyB0aGlzIHBhZ2UGOgpAdXNlZHsGOwhG\n','2009-08-07 23:57:56','2009-08-07 23:57:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscription_plans`
--

LOCK TABLES `subscription_plans` WRITE;
/*!40000 ALTER TABLE `subscription_plans` DISABLE KEYS */;
INSERT INTO `subscription_plans` VALUES (1,'Free','0.00','2009-07-16 18:10:59','2009-07-16 18:10:59',2,1,NULL,1,0),(2,'Basic','10.00','2009-07-16 18:10:59','2009-07-16 18:10:59',5,1,NULL,1,0),(3,'Premium','30.00','2009-07-16 18:10:59','2009-07-16 18:10:59',NULL,1,NULL,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (1,'0.00','2009-08-16 18:11:34',NULL,NULL,'2009-07-16 18:11:34','2009-07-16 18:11:34','active',1,2,2,1,NULL),(2,'0.00','2009-08-27 17:09:38',NULL,NULL,'2009-07-27 17:09:38','2009-07-27 17:09:38','active',1,3,2,1,NULL),(3,'0.00','2009-08-28 23:32:32',NULL,NULL,'2009-07-28 23:32:32','2009-07-28 23:32:32','active',1,4,2,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,2,'Content','2009-08-10 22:52:56',4),(2,2,9,'Content','2009-08-10 22:53:50',4),(3,2,41,'Content','2009-08-10 23:18:35',4),(4,1,44,'Content','2009-08-10 23:18:53',4),(5,2,57,'Content','2009-08-11 18:59:49',4),(6,1,59,'Content','2009-08-11 18:59:59',4),(7,2,80,'Content','2009-08-11 20:02:05',4),(8,1,92,'Content','2009-08-11 20:03:17',4);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'tracy ballard'),(2,'linda nelle edmond');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'peter@fadelhintz.uk','peter@fadelhintz.uk','ed9e4a3c0a3b3bd1b78385c565ba0f9b7477d7f56dbb1aede8b00a9ff2f4b585cb29ffd25a1baa8c8f9ffed4dc5797f89b6d36f81ac13af6ce440e5f5a4e2a59','2009-07-13 05:27:32','2009-07-13 05:27:33','779369986875d525708a1816addc86c11e25fe38','2009-07-13 05:27:32',NULL,'live',NULL,NULL,5,'Member',NULL,'Adams','facebook','HubBwwmQCNFAqtWtTBV9',504883639,NULL,NULL,NULL,0,'774c61a982e1bfb59db134b6f00f1a8913241b068268b9d4477c8c73ad6a848344dfc9bd04529496ad7a39331674761938c64fc1db89d604c228040ec55f0c60',NULL,NULL,NULL,'rwq82qfYIggkMfdF5kst',0,'oMlcrlaGX_8C6b3_C9oXqw__','2.DPd4uDYC2w7fBrDtg3IRZA__.86400.1246140000-504883639',NULL),(2,'marc@eternos.com','marc@eternos.com',NULL,'2009-07-16 18:11:34','2009-08-11 20:43:05',NULL,'2009-07-16 18:11:34',NULL,'live',NULL,NULL,5,'Member',2,'Mauger','Marc',NULL,1005737378,'2009-08-11 20:43:05','::1','2009-08-11 20:35:12',50,'05744e51782b5617d5bd752fcdf3adb5fa7b56633382ee6d848890e905240ddebe707b81e23980999424f230e65953ab59686b01b70eb891921586419e32f1fb','::1','2009-08-11 16:07:08',NULL,'gecSHeDu7ya37ATqHfzf',0,'6ef09f021c983dbd7d04a92f3689a9a5','c4c3485e22162aeb0be835bb-1005737378',NULL),(3,'simian187@eternos.com','simian187@eternos.com','eca53e0d83430690db261753acdc52b6f72cb98cf7b5baf978fea91402a1a887b223d8150ff42c4d038ea1a0fb0a33a5f8806a3bc1306dba75ae6233230fbf42','2009-07-27 17:09:37','2009-07-27 17:10:47',NULL,'2009-07-27 17:09:38',NULL,'live',NULL,NULL,5,'Member',3,'phil','dr','Nl-z-nUyfRg3pOuOz8vV',NULL,'2009-07-27 17:10:47','::1','2009-07-27 17:09:37',1,'bbc4476baa6ecd695b0188ff52baaa95c07a8eb9ec7708533442eb80af6654ab90271de4caa7d5f0613f77d45131665dd7197bb6bfc09fec453f53182298423a',NULL,NULL,NULL,'5ENIBlboOaOPpqD4AvRh',0,NULL,NULL,NULL),(4,'eternos44@mailinator.com','eternos44@mailinator.com','983c4d7a0779c60b6e1c66b30ad53d9f50787881e63cd057058aec18ccfd1cf0be0716b30d8707ce29170cc8eb014e429d2114397a6d5b38b3446eb3af4976cc','2009-07-28 23:32:32','2009-07-29 21:15:08',NULL,'2009-07-28 23:32:32',NULL,'live',NULL,NULL,5,'Member',4,'tastical','crap','jB3v0aIvUFeob_AEQnwZ',NULL,'2009-07-29 21:15:08','::1','2009-07-29 21:14:23',2,'de5771659efc83a562592019ca36121a763f0b3b967fa2d9a0faec52a60518a128093b3a494725222885cc1005b4c15027701b4455e661aff5d69d78ab2e3f47','::1','2009-07-28 23:32:32',NULL,'iVlWGC-d2Y0V4t2-o_bB',0,NULL,NULL,NULL);
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

-- Dump completed on 2009-08-11 22:00:37
