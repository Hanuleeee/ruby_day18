# 20180704_Day17

#### 기술면접 문제

* 브라우저가 HTML을 그리는 과정을 설명하시오

  > [참고문서](https://d2.naver.com/helloworld/59361)



### jQuery

------

* jQuery(요소 선택자, 이벤트 리스너) 

* 원래는 `jquery cdn`에서 가져와야하지만,`rails`에는 자바스크립트가 내장되어있다. 



#### 요소선택자

$ 에 우리가 사용할 jquery가 모두 담겨있다.

```javascript
$(".btn") 
// = getElementsByClassName   
// class를 찾을때는 .을 쓴다.

$('#title')
// = getElementById  
// id를 찾을때는 #을 쓴다.
```



#### 첫번째 형태

```javascript
 $('.btn').이벤트명(이벤트핸들러)

$('.btn').mouseover(function(){
    alert("건드리지마.. 아프니까..ㅜㅠ")
})
```

* 어제는 이벤트를 돌면서 하나씩넣어줘야했지만(이벤트리스너, 이벤트핸들러 각각해줘야함)
  javascript의 `getElementByClassName`과는 달리 jQuery는 요소선택자 하나로 일괄적용된다.(btn class를 가진 모든 것)



#### 두번째 형태

```javascript
// javascript의 addEventListner과 비슷함
$('.btn').on('이벤트명', function() {});

$('.btn').on('mouseover', function(){
    console.log("건드리지 말랬지..ㅡㅡ");   
});
```





* mouse가 버튼위에 올라갔을 때, button에 있는 btn-primary 클래스를 삭제하고 btn-danger 클래스를 준다. mouse가 버튼에서 내려왔을 때, 다시 btn-danger 클래스를 삭제하고 btn-primary 클래스를 추가한다.
* 여러개의 이벤트 등록하기
* 요소에 class를 넣고 빼는 jQuery function을 찾기.



```javascript
var btn =$(".btn")
btn.on('mouseenter mouseout', function(){
    btn.removeClass("btn-primary").addClass("btn-danger");
})

btn.on('mouseenter mouseout', function(){
    if(btn.hasClass('btn-danger')){
        btn.removeClass('btn-danger').addClass('btn-primary');
    } else{
        btn.removeClass('btn-primary').addClass('btn-danger');
    }
})
```



#### toggleClass : remove + add 기능

>  http://api.jquery.com/toggleclass/

```javascript
// 이벤트가 발생한 곳뿐만아니라 모든 btn 클래스가 같이 반응한다.
var btn =$('.btn')
btn.on('mouseenter mouseout', function(){
    btn.toggleClass('btn-danger').toggleClass('btn-primary');
})

//이벤트가 발생한 자기 자신만 반응한다.
var btn =$('.btn')
btn.on('mouseenter mouseout', function(){
    $(this).toggleClass('btn-danger').toggleClass('btn-primary');
})

var btn =$('.btn')
btn.on('mouseenter mouseout', function(){
    $(this).toggleClass('btn-danger').toggleClass('btn-primary');
    console.dir(this);
    console.dir($(this));
});
```

* `this` : html 요소 자체
* `$(this)` : 이벤트가 발생한 바로 그 대상(자신)을 지칭, **jquery 객체**
* 즉, toggleclass는 jQuery객체이므로 $(this)를 써야한다.



* 버튼에 마우스가 오버됐을 때,                                      										상단에 있는 이미지의 속성에 style 속성과 `width: 100px` 의 속성값을 부여한다. 

  > https://www.w3schools.com/jquery/html_attr.asp

```javascript
// 속성 부여
var btn = $('.btn')
btn.on('mouseover', function(){
     $('img').attr('style', 'width: 100px');
})

$('img').attr('style');   // 먼저찾은 값을 리턴
```



#### 텍스트 바꾸기   : `.text` 메서드 

> https://www.w3schools.com/jquery/html_text.asp

* text안에 문자열이 있으면 그 문자열로 바꿔주고 아무것도 없을때는 그안에 있는 innertext 속성을 꺼내온다.

```javascript
btn.on('mouseover', function(){
    $('.card-title').text("Don't touch me!!!!");
});
```



* 버튼(요소)에 마우스가 오버(이벤트)됐을 때(이벤트 리스너), 이벤트가 발생한 버튼($(this))과 상위 수준에 있는 요소(parent()) 중에서 `.card-title`의 속성을 가진 친구를 찾아(find) 텍스트를 변경(text)시킨다.   -> 잘 사용하진않음

```javascript
var btn = $('.btn')
btn.on('mouseover', function(){
    $(this).siblings().find('.card-title').text("건드리지마...ㅡ,ㅡ");
})

btn.on('mouseover', function(){
    $(this).parent().find('.card-title').text("건드리지마...ㅡ,ㅡ");
})
```





### 텍스트 변환기(오타치는 사람 놀리기)  - `Atom` 사용

------

> <https://github.com/e-/Hangul.js> 

*index.html*

```html
<textarea id="input" placeholder="변환할 텍스트를 입력해주세요."></textarea>
<button class="translate">바꿔줘</button>
<h3></h3>
```

* input에 들어있는 텍스트 중에서 '관리' -> '고나리', '확인' -> '호가인',  '훤하다' -> '허누하다' 의 방식(분해한 글자의 4번째 요소가 있는지 && 2,3 번째 요소 모음) 으로 텍스트를 오타로 바꾸는 이벤트 핸들러 작성하기

* https://github.com/e-/Hangul.js 에서 라이브러리를 받아서 자음과 모음을 분리하고, 다시 단어로 합치는 기능 살펴보기

* `String.split('')` : `''`안에 있는 것을 기준으로 문자열을 잘라준다. (return type: 배열)

* `Array.join('')` : 

* `Array.map(function(el){})` : 배열을 순회하면서 하나의 요소마다 function을 실행시킴  

  (el: 순회하는 각 요소, return type: 새로운 배열)



1. textarea에 있는 내용물을 가지고 오는 코드

   ```javascript
   var input = $('#input').val();
   // id='input'인 태그의 value를 input 변수에 저장
   ```

   

2. 버튼에 이벤트 리스너(click)를 달아주고, 핸들러에는 1번에서 작성한 코드를 넣는다.

   ```javascript
   ...
   	<textarea id="input" placeholder="변환할 텍스트를 입력해주세요."></textarea>
   ...
        $('.translate').on('click', function(){
          var input = $('#input').val();
          console.log(input);
        })
   ```

   

3. 1번 코드의 결과물을 한글자씩 분해해서 배열로 만들어 준다. (split(''))

   ```javascript
   var result = input.split('');    //추가
   ```

   

4. 분해한 글자의 4번째 요소가 있는지 && 2,3 번째 요소가 모음이여야한다.

5. switch

6. 결과물로 나온 배열을 문자열로 이어준다( `join` )

   ```javascript
   function translate(str){
     return str.split('').map(function(el){
       var d= Hangul.disassemble(el);
       if(d[3] && Hangul.isVowel(d[1]) && Hangul.isVowel(d[2])){
         var tmp = d[2];    //switch
         d[2] = d[3]
         d[3] = tmp;
       }
       return Hangul.assemble(d);  
     }).join('');     //join
     //string받아서 분해해서 (배열) 하나씩 돌면서 조작하고 다시 조인(메서드 체이닝)
   }
   ```

     *자바스크립트는 리턴값이 꼭 있어야한다.*

   

7. 결과물을 출력해줄 요소를 찾는다.

   ```javascript
   ...
       <textarea id="input" placeholder="변환할 텍스트를 입력해주세요."></textarea>
       <button class="translate">바꿔줘</button>
       <h3></h3>    //이 위치에 출력
   ...
   $('h3').text(result);    
   ```

   

8. 요소에 결과물을 출력한다. 



### Ajax

------

* 자바스크립트로 요청을 보내면 자바스크립트로 응답이 온다. 자바스크립트 중간에 서버로 요청을 보낸다.  응답으로 보낼 자바스크립트 코드에다가 ajax로 꾸며진걸 넣어서 보내준다. 

* 요청을 보낼때 `route`에다가 어느 메소드(액션)으로 보낼지 지정해놓는다. 자바스크립트는 어디로 보내는지(`url`, `Http method`)만 알고 있으면 된다.
* 화면전환없이 서버에다가 요청보내고 응답받을 수 있기때문에 많이 사용한다



```javascript
$.ajax({
    url: 어느 주소로 요청을 보낼지,
    method: 어떤 http method 요청을 보낼지,
    data: {
        k: v 어떤 값을 함께 보낼지,
        // 서버에서는 params[k] => v
    }
})
```

> Google에 'jquery ajax' 검색해서 위에서부터 4개 읽어보기



### '좋아요' 버튼 만들기

------

1. 좋아요 버튼을 눌렀을 때
2. 서버에 요청을 보낸다. (현재 유저가 현재 보고있는 이 영화가 좋다고 하는 요청 )
3. 서버가 할일 
4. 응답이 오면 `좋아요 ` button의 텍스트를 `좋아요 취소`로 바꾸고, `btn-info` -> `btn-warning text-white`로 바꿔준다.



```bash
hanullllje:~/watcha_app (master) $ rails g model like
```

*db/migrate/create_like*

```ruby
t.integer   :user_id  #추가
t.integer   :movie_id
```



#### 모델 관계 설정

*app/models/like.rb*

```ruby
class Like < ApplicationRecord
    belongs_to :user
    belongs_to :movie
end
```

*app/models/movies.rb*

```ruby
class Movie < ApplicationRecord
    mount_uploader :image_path, ImageUploader
    # belongs_to :user    # 삭제
    has_many :likes
    has_many :users, through: :likes  #추가
end
```

*app/models/user.rb*

```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :likes       # 추가
  has_many :movies, through: :likes
end
```



'*app/views/movies/show.html.erb*'

```erb
<button class="btn btn-info like">좋아요</button>
<script>
//document가 다 준비된(load) 다음 동작해라 
//html보다 js가 먼저 작동할 위험이 사라짐(항상 여기에 넣기)
$(document).on('ready',function(){
    $('.like').on('click', function(){  //클래스로 좋아요 버튼 찾기
        console.log("like!!!"); 
        $.ajax({
           url: '/likes/<%= @movie.id %>' 
        });
    })  
});  
</script>
```

*routes.rb*

```ruby
get '/likes/:movie_id' => 'movies#like_movie'   # 추가
```

*app/controllers/movie_controller.rb*

```ruby
before_action :js_authenticate_user!, only: [:like_movie]    
# 추가('application_controller'에 메소드 정의, 나머지 authenticate_user은 devise에 구현되어 있다.)
...
...
   def like_movie
    p params
    # 현재 유저와 params에 담긴 movie간의 좋아요 관계를 설정한다.
    # 만약에 현재 로그인한 유저가 이미 좋아요를 눌렀을 경우-> 해당 Like 인스턴스 삭제
    # 새로 누른 경우 -> 좋아요 관계 설정
    @like = Like.where(user_id: current_user, movie_id: params[:movie_id]).first
    if @like.nil?
      @like = Like.create(user_id: current_user, movie_id: params[:movie_id])
    else
      @like.destroy
    end
    
    # @like.frozen? # @like.destroy처럼 삭제된경우 에는 사용하지못하도록 얼어있어.
    # -> true 라면 좋아요취소된친구
    
    # 현재 유저와 params에 담긴 movie간의 좋아요 관계를 설정한다.
    # Like.create(user_id: current_user.id, movie_id: params[:movie_id])

    puts "좋아요 설정 끝"
  end
...
```



*views/movies/show.html.erb*

```erb
<h1><%= @movie.title %></h1>
<hr>
<p><%= @movie.description %></p>
<%= link_to 'Edit', edit_movie_path(@movie) %> |
<%= link_to 'Back', movies_path %>
<hr></hr>
<button class="btn btn-info like">좋아요</button>
<script>
//document가 다 준비된(load) 다음 동작해라 
//html보다 js가 먼저 작동할 위험이 사라짐(항상 여기에 넣기)
$(document).on('ready',function(){
    $('.like').on('click', function(){  //클래스로 좋아요 버튼 찾기
        console.log("like!!!"); 
        $.ajax({
           url: '/likes/<%= @movie.id %>' 
        });
    })  
});  
</script>
```



*app/views/movies/like_movie.js.erb*  생성   : 유저에게 java script로 응답

```js
alert("좋아요 설정됐쩡");
$('.like').text("좋아요 취소").toggleClass("btn-warning btn-info text-white");  
//좋아요 취소로 바꿈
```

