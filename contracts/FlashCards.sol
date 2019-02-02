pragma solidity >=0.5.0<0.6.0;

contract FlashCards {

  struct AccountInfo {
    address addr;
    bool exists;
    uint[] favFlashCards;
    uint[] subFlashCards;
    uint[] audFlashCards;
  }

  struct Answer {
    uint id;
    string aBody;
  }

  struct Question {
    uint id;
    string qBody;
    mapping(uint => Answer) answers;
    uint numberAnswers;
    uint rightAnswer;
  }

  struct Language {
    uint id;
    string langName;
  }

  struct Category {
    uint id;
    string catName;
  }

  struct FlashCard {
    uint id;
    uint categoryId;
    uint langId;
    uint usedCounter;
    uint complCounter;
    address subm;
    address aud;
    uint numberOfQuestions;
    mapping(uint => Question) questions;
  }

  address public admin;
  Language[] public langList;
  Category[] public categoryList;
  FlashCard[] public flashCardList;

  uint public allAccountsCount;
  mapping(address => AccountInfo) public allAccounts;
  address[] public allAccountAddresses;

  constructor() public {
    admin = msg.sender;
    generateSampleLanguages();
    generateSampleCategories();
    generateVanillaPack();
  }

  modifier isAdmin() {
    require(msg.sender == admin, "Not an admin");
    _;
  }

  modifier accountExists(address _addr) {
    require(allAccounts[_addr].exists == true, "Account doesn't exist");
    _;
  }

  modifier accountNotExists(address _addr) {
    require(allAccounts[_addr].exists == false, "Account already exists");
    _;
  }

  event AccountCreated(uint _id, address _addr);

  function generateSampleLanguages() isAdmin() internal {
    uint curNum = langList.length;
    langList.push(Language({id: ++curNum, langName: "English"}));
    langList.push(Language({id: ++curNum, langName: "German"}));
    langList.push(Language({id: ++curNum, langName: "Russian"}));
  }

  function generateSampleCategories() isAdmin() internal {
    uint curNum = categoryList.length;
    categoryList.push(Category({id: ++curNum, catName: "Cooking"}));
    categoryList.push(Category({id: ++curNum, catName: "Travel"}));
    categoryList.push(Category({id: ++curNum, catName: "Drinking"}));
  }


  function generateVanillaPack() isAdmin() internal {
    uint curNum = flashCardList.length;
    uint qCounter = 0;

    Question memory tmpQ1 = Question({
        id: 1,
          qBody: "Я нашел СуперСуса",
          numberAnswers: 2,
          rightAnswer: 2
          });

    Question memory tmpQ2 = Question({
        id: 2,
          qBody: "Я ебу Собак",
          numberAnswers: 3,
          rightAnswer: 3
          });

    FlashCard memory curFlash = FlashCard({
        id : ++curNum,
          categoryId: 1,
          langId: 1,
          numberOfQuestions: 2,
          usedCounter: 0,
          complCounter: 0,
          subm: msg.sender,
          aud: msg.sender
          });

    flashCardList.push(curFlash);
    FlashCard storage cur2Flash = flashCardList[0];
    cur2Flash.questions[++qCounter] = tmpQ1;
    cur2Flash.questions[++qCounter] = tmpQ2;
    Question storage q1 = cur2Flash.questions[1];
    Question storage q2 = cur2Flash.questions[2];

    q1.answers[1] = Answer({id: 1, aBody: "I want to fuck SuperSus"});
    q1.answers[2] = Answer({id: 2, aBody: "I found SuperSus"});

    q2.answers[1] = Answer({id: 1, aBody: "I hate dogs"});
    q2.answers[2] = Answer({id: 2, aBody: "I fuck with dogs"});
    q2.answers[3] = Answer({id: 3, aBody: "I love cats"});
  }

  function createAccount() public accountNotExists(msg.sender) returns (uint _id) {
    allAccountsCount++;
    allAccountAddresses.push(msg.sender);
    allAccounts[msg.sender] = AccountInfo({
        addr: msg.sender,
          exists: true,
          favFlashCards: new uint[](0),
          subFlashCards: new uint[](0),
          audFlashCards: new uint[](0)
          });

    emit AccountCreated(allAccountsCount, msg.sender);
    return allAccountsCount;
  }

  function accountRegistered() public view returns (bool) {
    return allAccounts[msg.sender].exists == true;
  }

  function getSubmittedFlashcards(address _addr) public view accountExists(_addr) returns(uint[] memory) {
    uint submittedFlashCardsCount = allAccounts[_addr].subFlashCards.length;
    uint[] memory ids = new uint[](submittedFlashCardsCount);

    for (uint i = 0; i < submittedFlashCardsCount; i++) {
      ids[i] = allAccounts[_addr].subFlashCards[i];
    }
    return ids;
  }

  function getFavoriteFlashcards(address _addr) public view accountExists(_addr) returns(uint[] memory) {
    uint favoriteFlashCardsCount = allAccounts[_addr].favFlashCards.length;
    uint[] memory ids = new uint[](favoriteFlashCardsCount);

    for (uint i = 0; i < favoriteFlashCardsCount; i++) {
      ids[i] = allAccounts[_addr].favFlashCards[i];
    }
    return ids;
  }

  function getAuditedFlashcards(address _addr) public view accountExists(_addr) returns(uint[] memory) {
    uint auditedFlashCardsCount = allAccounts[_addr].audFlashCards.length;
    uint[] memory ids = new uint[](auditedFlashCardsCount);

    for (uint i = 0; i < auditedFlashCardsCount; i++) {
      ids[i] = allAccounts[_addr].audFlashCards[i];
    }
    return ids;
  }

}
