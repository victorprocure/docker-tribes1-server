$Server::Address = "#ServerAddress#";
$Server::Port = "#ServerPort#";
$AdminPassword = "#ServerAdminPassword#";
$Server::Game = "Tribes";
$Server::HostName = "#ServerHostName#";
$Server::Info = "#ServerInfo#";

$Server::MaxPlayers = "#ServerMaxPlayers#";
$Server::TimeLimit = "#ServerTimeLimit#";
$teamScoreLimit = "#ServerTeamScoreLimit#";

$Console::LogMode = "1";
$Server::LogAdmins = "true";
$Server::LogFile = "ServerLog.cs";
$Server::LogKickBan = "true";
$Server::LogMissionChange = "true";
$Server::AutoAssignTeams = "true";
$Server::BanFile = "Server/Bans.cs";
$Server::AllowRape = "false";
$Server::AntiRape = "true";
$Server::AntiRape::minTeamSize = "8";

$Server::HostPublicGame = "#ServerPublicGame#";
$Server::CurrentMaster = "1";
$Server::Master1 = "t1m1.pu.net:28000";
$Server::MasterAddressN0 = "t1m1.pu.net:28000";
$Server::MasterAddressN1 = "t1m1.tribes1.co:28000";
$Server::MasterAddressN2 = "tribes.lock-load.org:28000";
$Server::MasterAddressN3 = "t1m1.tribes0.com:28000";
$Server::MasterName0 = "bugs_";
$Server::MasterName1 = "kigen";
$Server::MasterName2 = "lock-load";
$Server::MasterName3 = "plasmatic";
$Server::XLMasterN0 = "IP:74.117.210.42:28000";
$Server::XLMasterN1 = "IP:198.50.214.196:28000";
$Server::XLMasterN2 = "IP:72.54.15.111:28000";
$Server::XLMasterN3 = "IP:173.27.38.102:28000";

$pref::PacketRate = "#PacketRate#";
$pref::PacketSize = "#PacketSize#";

Server::loadMission("Raindance");
