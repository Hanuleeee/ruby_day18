# Day16 (20180703)



### Watch(영화 정보 저장)

```bash
hanullllje:~/workspace $ gem install rails -v 5.0.7
```

```bash
hanullllje:~ $ rails _5.0.7_ new watcha_app
```



* scaffold

  ```bash
  hanullllje:~/watcha_app $ rails g scaffold movies
  ```

  '*routes*'  `root 'movies#index' `  추가

  

  '*Gemfile*'     	

  ```ruby
  gem 'turbolinks', '~> 5'  #주석처리
  ```

  : `turbolinks` 3군데서 제외시킴

  

  *app/assets/javascripts/application.js*

```ruby
#삭제
//= require turbolinks   
//= require_tree .

#추가
//= require popper   
//= require bootstrap
```

*app/assets/stylesheets/application.scss*

```scss
//있는거 다지우고 추가
@import 'bootstrap';
```

*application.html.erb*

```erb
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload'%>
↓↓  <!--수정 -->
<%= javascript_include_tag 'application'%>
```



* user authenticate(**devise**)

  ```bash
  hanullllje:~/watcha_app $ rails g devise:install
  ```

  '*config/environment/development.rb*'

  ```ruby
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } #추가
  ```

  ```bash
  hanullllje:~/watcha_app $ rails g devise users
  ```

  

* db 구축

  '*db/migrate/create_movies*'   : 컬럼설정

  ```ruby
  class CreateMovies < ActiveRecord::Migration[5.0]
    def change
      create_table :movies do |t|
        t.string    :title
        t.string    :genre
        t.string    :director
        t.string    :actor
        
        t.integer   :user_id  #외래키
        
        t.text      :description
        t.timestamps
      end
    end
  end
  
  ```

  '*app/models/movie.rb*'   :  관계설정 (1:m)

  ```ruby
  belongs_to :user
  ```

  '*app/models/user.rb*'  

  ```ruby
  has_many :movies
  ```

  

  ```bash
  hanullllje:~/watcha_app $ rake db:migrate  # db 구동
  ```

  

* comment model

* image upload(local)

  ```bash
  hanullllje:~/watcha_app $ rails g uploader image
  ```

  

  ```ruby
  # beautify
  gem 'bootstrap', '~> 4.1.1'
  # authentication
  gem 'devise'
  # file upload
  gem 'carrierwave'      # 이미지 업로더
  
  group :development do
      gem 'rails_db'     # 추가
  end
  ```

  ```bash
  hanullllje:~/watcha_app $ bundle install
  ```

  

  ```bash
  hanullllje:~/watcha_app $ sudo apt-get update
  hanullllje:~/watcha_app $ sudo apt-get install imagemagick
  ```

  지난번에 한 **Image Uploader** 참고



### CSS Selector

`F12 -> console` 

* 요소 여러개 찾는 방법

  * document.getElementsByClassName

  * document.getElementsByTagName
  * document.querySelectorAll

* 요소 한개만 리턴시켜줌 (id는 하나만 있어야 한다.)
  * document.getElementByID 

* 먼저 발견된 하나의 요소만 리턴시켜줌

  * document.querySelector

  ```javascript
  var btn = document.getElementsByClassName("btn");
  btn
  HTMLCollection(2) [a.btn.btn-primary, a.btn.btn-primary]
  ```



* 3가지

  ```
  console.log
  console.error
  console.dir
  ```

* "이벤트" 

  이벤트를 감지해서 다른 행동(행위)이 발생하게끔 

  (이벤트 감지 = 이벤트 리스너)  (이벤트 핸들러)

  Ex. '하이' 라고 쓰여있는 버튼을 눌렀더니 '바이'라고 바뀜

  ```javascript
  btns[0].onmouseover = alert("하이!")
  undefined
  alert("hi");
  undefined
  confirm("삭제하시겠습니까?");
  false
  prompt("이름을 입력하세요");
  "하이"
  ```

  

* 요소.onClick = 어떤행위?



* 이벤트 등록하는 방법 2가지 (on[event] , addeventlistener)

  ```javascript
  1. 요소.on[이벤트이름] = function(매개변수){
  	 //이벤트리스너	//이벤트핸들러(이벤트가 발생했을때 동작하는 행동)
    					 ...
    					 alert("건드리지마");
   					 }
  
  ```

  ```javascript
  var btn = document.getElementsByClassName("btn");
  btn[0]
  <a class="btn btn-primary" href="/movies/1">영화 정보보기</a>
  btn[0].onmouseover = function(){ alert("나 건드리지마!!!");}
  ƒ (){ alert("나 건드리지마!!!");}
  ```

  

* 함수 3가지

  1. 함수표현
  2. 함수선언
  3. 익명함수





**자바스크립트**

* 기본적인 JS 설명(front)

> 1. 마우스를 오버하면 "나 건드리지 마!!" 라는 alert()를 띄움
> 2. 마우스 오버를 10회 이상 하면 "아 진짜 건드리지 말라고" 라는 alert()를 띄움
>
> ```javascript
> if(조건){
>     실행문
> } else {
>     실행문
> }
> ```
>
> * count
> * msg
>
> ```javascript
> var btn = document.getElementsByClassName("btn")[0];
> 
> var count = 0;
> var msg= "나 건드리지마!!";
> 
> btn.onmouseover= function(){
>     count++;
>     if(count >3) { 
>         msg= "아 진짜 그만 건드리라구!!!!";
>     } 
>     alert(msg);
> }
> 
> console.dir(btn);
> ```

* 이벤트 등록하는 방법
* 함수 만들기 (function())

```javascript
<!-- 자바스크립트 -->
<script>
func2;
var func1 = function(){
  alert("하위~1");
  // 함수 표현식
  // 선언되기 이전에 사용할 수 없다.
}
func1;
function func2(){
  alert("하위~2");
  // 함수 선언식
  //선언되기 이전에도 사용할 수 있다.
}

// 실행
var btn = document.getElementsByClassName("btn")[0];
btn.addEventListener("mouseover", func2); // func2() : 이건 함수 실행, 함수명만 적어야 함수 등록

var btn2 = document.getElementsByClassName("btn")[1];
btn2.onmouseover =func1;  //함수 이름만 적어줘야 함수가 정상적으로 등록됨

// 먼저 선언되어 있던 함수를 이벤트 핸들러로 사용할 경우
// 함수 이름만 적어서 사용한다.
// 함수이름() <- 이 형태는 함수의 실행을 의미한다.
</script>
```







* 이벤트 동작시키기 + jQuery + ajax
* 댓글달기 + 수정 + 삭제
* 좋아요 + 별점
* infinity controll





* 사용자 기능정의 (금욜)
  * page에 어떤게들어갈건지.. UI
  * 회원가입
  * 메인페이지
  * 게시판 목차
  * 게시판 입력창
  * 게시판 수정창(입력창)
  * 게시글 보기창
  * ...

```
p @instance.errors 
```

