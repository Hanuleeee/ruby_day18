# 20180705_Day18



### 복습

* ajax : 비동기 자바스크립트

  페이지하나 동작하는 중간에 서버에 요청을 보내서 페이지에 Reload없이 서버에서받은 데이터로 요소들을 변화시키는것 

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

* 처음 `show.html.erb` 에서 url, method, data 를 지정해주고, 이 요청을 받아드릴 `routes` 에 해당 url을 컨트롤러에 지정한다.
* *movies_controller* 에서 좋아요, 좋아요 취소 로직을 설정했다.

 



## 좋아요 버튼 + 개수 넣고 변화하는 것

* controller에 like_movie 메소드 추가

* `__.frozen?` : 이 메소드로 좋아요가 새로 만들어 진 것인지, 삭제를 한 건지 알 수 있다.

 

*views/movies/show.html.erb*

```erb
...
<% if @user_likes_movie.nil? %>
<button class="btn btn-info like">좋아요 (<span class="like-count"><%=@movie.likes.count%></span>)</button>
<% else %>
<button class="btn btn-warning like text-white">좋아요 취소 (<span class="like-count"><%=@movie.likes.count%></span>)</button>
<% end %>
...
<script>
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

 

*routes* 설정 :  `  get '/likes/:movie_id' => 'movies#like_movie'`



*app/controllers/movies_controller.rb*

```ruby
  def like_movie
    p params
    # 현재 유저와 params에 담긴 movie간의 좋아요 관계를 설정한다.
    # 만약에 현재 로그인한 유저가 이미 좋아요를 눌렀을 경우-> 해당 Like 인스턴스 삭제
    # 새로 누른 경우 -> 좋아요 관계 설정
    @like = Like.where(user_id: current_user.id, movie_id: params[:movie_id]).first
    if @like.nil?
      @like = Like.create(user_id: current_user.id, movie_id: params[:movie_id])
    else
      @like.destroy
    end
    puts @like.frozen? #이메소드로 새로만든건지, 삭제를 한건지 알수있다.
    # @like.frozen? # @like.destroy처럼 삭제된경우 에는 사용하지못하도록 얼어있어.
    # -> true 라면 좋아요취소된친구
    puts "좋아요 설정 끝"
  end
```

 

*views/movies/like_movie.js.erb*

```erb
var like_count = parseInt($('.like-count').text());  //문자열이기때문에 숫자로 바꿔주어야 count가능

console.log(like_count);
if(<%= @like.frozen? %>){
	//좋아요가 취소된 경우-  좋아요 취소버튼 -> 좋아요 버튼
    alert("좋아요 취소");
    like_count = like_count - 1;
    $('.like').html(`좋아요( <span class='like-count'>${like_count}</span> )`).addClass("btn-info").removeClass("btn-warning text-white");
} else {
	//좋아요가 새로 눌린경우-  좋아요 버튼 -> 좋아요 취소 
    alert("좋아요 설정됐쩡");
    like_count = like_count + 1;
    $('.like').html(`좋아요 취소( <span class='like-count'>${like_count}</span> )`).addClass("btn-warning text-white").removeClass("btn-info");
}
```



`" "`  `' '`  : 줄바꿈 X

` `` ` : 줄바꿈 O

 

 

## 댓글 창 만들기

 

- 댓글을 입력받을 폼을 작성
- form(요소)이 제출(이벤트)될 때(이벤트 리스너)
- form에 input(요소)안에 있는 내용물(메소드)을 받아서
- ajax요청으로 서버에 '/create/comment'로 id값도 같이 보낸다.
- 서버에서 저장하고, response 보내줄 js.erb 파일을 작성한다.
- js.erb 파일에서는 댓글이 표시될 영역에 등록된 댓글의 내용을 추가해준다.

 

### comment model 만들기 

`$ rails g model comment`

* column:user_id, movie_id, contents

* association:

  * movie(1) - comment(N)
  * user(1) - comment(N)
  * 한유저가 여러개의 무비에 댓글을 달 수 있고 무비도 여러사람에게 댓글을 받을 수 있다.

* url("movies/:movie_id/comments", method:post) 인 ajax 코드 짜보기

  

*app/views/movies/show.html.erb*  : db저장 전

```erb
<form class="text-right comment">
    <input class="form-control comment-contents">
    <input type="submit" value="댓글쓰기" class="btn btn-primary">
</form>
<hr>
<h3>댓글</h3>
<ul class="list-group comment-list">
  <!--<li class="list-group-item">Cras justo odio</li>-->
</ul>
<hr>
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
    $('.comment').on('submit', function(e) {   //추가
        e.preventDefault();   //이게뭐라고?
        var comm = $('.comment-contents').val();
        console.log(comm);
        $('.comment-list').prepend(`<li class="list-group-item">${comm}</li>`); 			//append와 prepend 차이 알아둬
        $('.comment-contents').val('');
    });
});  
</script>
```

* `.append` : 제일끝에 추가시키는 jquery 메소드

  `.prepend` : 앞에 추가시키는 jquery메소드



### 새로운 routes 설정 방법

>  [2.7 Nested Resources](http://guides.rubyonrails.org/routing.html#nested-resources)

```ruby
resources :movies do
  member do    # id까지 포함
    get '/test' => 'movies#test_member'
  end
  collection do
    get '/test' => 'movies#test_collection'
  end
end

# `rake routes`
 test_movie GET    /movies/:id/test(.:format)     movies#test_member
 test_movies GET    /movies/test(.:format)         movies#test_collection
```

따라서, 다음과 같이 *routes*를 설정할 수 있다.

```ruby
post '/movies/:movie_id/comments' => 'movies#comments'
# 중복되니까 이렇게 쓰지않고.
```

```ruby
resources :movies do
  member do    # id까지 포함
    post '/comments' => 'movies#create_comment'
  end
end

# `rake routes`
 comments_movie POST    /movies/:id/comments(.:format) movies#create_comment
```



* `create_comment` 메소드 설정

*app/controllers/movies_controllers*

```ruby
before_action :set_movie, only: [:show, :edit, :update, :destroy, :create_comment] #추가
...
   def create_comment
    # @movie = Movie.find(params[:id])  #before_action에 정의
    @comment = Comment.where(user_id: current_user.id, movie_id: @movie.id, contents: params[:contents])
    # @movie.comments.new(user_id: current_user.id).save  #위의 축약형
  end

...  
```



* 기존에 등록되어 있는 댓글 출력하기

*app/controllers/movies_controllers*

```erb
...
<ul class="list-group comment-list">
  <!-- 기존에 등록되어 있는 댓글 출력하기 -->
  <% @movie.comments.reverse.each do |comment|%>  
  <li class="comment-<%= comment.id%> list-group-item d-flex justify-content-between">
      <span class="comment-detail-<%=comment.id%>"><%= comment.contents %></span>
  </li>
  <% end %>
</ul>
...
```

현재 유저가 등록한 댓글들 => `user.comments`

영화 하나가 가지고 있는 댓글들 => `movie.comments`



## 댓글 삭제버튼 만들기 & 동작

  

* 댓글에 있는 삭제 버튼(요소)을 누르면(이벤트 리스너) 

  해당 댓글이 눈에 안보이게 되고(이벤트 핸들러), 

  실제 DB에서도 삭제가 된다(ajax).

   

*app/views/movies/show.html.erb*

```erb
...
<ul class="list-group comment-list">
  <!-- 기존에 등록되어 있는 댓글 출력하기 -->
  <% @movie.comments.reverse.each do |comment|%>  
  <li class="list-group-item d-flex justify-content-between">
      <span class="comment-detail-<%=comment.id%>"><%= comment.contents %></span>
      <button data-id="<%=comment.id %>" class="btn btn-danger destroy-comment">삭제</button>
  </li>
  <% end %>
</ul>
...
<script>
$(document).on('ready',function(){
    ...
    $('.destroy-comment').on('click', function(){
        console.log("destroyed!!!");
         $(this).parent().remove();   
        // = $(this).parent()의 바로위 부모 태그를 지운다.
    })
}); 
    
</script>
```

* `$(this).parent()`는 `.destroy-comment`의 자신의 바로위 부모태그. 

  즉, `li` 태그를 의미한다.



*views/movies/show.html.erb*  : ajax 추가(db에서 삭제)

```erb
<script>
...
    $(document).on('click', '.destroy-comment', function(){  //다시한번 reload!!하려고 document
        console.log("destroyed!!!");
        var comment_id = $(this).attr('data-id'); 
        //$(this).data('id');  //바로 위랑 똑같음
        $.ajax({
            url: "/movies/comments/" + comment_id,
            method: "delete"
        })
    });
 ...
</script>
```



*routes*

```ruby
  root 'movies#index'
  resources :movies do
      ...
    collection do  #추가
      delete '/comments/:comment_id' => 'movies#destroy_comment'
    end
  end
```



*app/controllers/movies_controller.rb*  :  `destroy_comment `메서드 추가

```ruby
...
 def destroy_comment
    Comment.find(params[:comment_id]).destroy
  end
...
```



*views/movies/destroy_commentjs/erb*  만들기

```erb
$('.comment-list').prepend(`
<li class="comment-<%= @comment.id%> list-group-item d-flex justify-content-between">
      <%= @comment.contents %> ...(<%= @comment.user.email %>)
      <button data-id="<%=@comment.id %>" class="btn btn-danger destroy-comment">삭제</button>
  </li>`);
$('.comment-contents').val('');
alert("댓글이 등록되었습니다.");
```





## 수정버튼 만들기 + 동작

  

[이벤트 리스너 + 이벤트 핸들러]

* 수정버튼을 클릭하면

* 댓글이 있던 부분이 입력창으로 바뀌면서 원래 있던 댓글의 내용이 입력창에 들어간다.

* 수정버튼은 확인 버튼으로 바뀐다.

   

### 수정버튼 추가

*app/views/movies/show.html.erb*   

```erb
...
<ul class="list-group comment-list">
  <!--<li class="list-group-item">Cras justo odio</li>-->
  <!-- 기존에 등록되어 있는 댓글 출력하기 -->
  <% @movie.comments.reverse.each do |comment|%>  
  <li class="comment-<%= comment.id%> list-group-item d-flex justify-content-between">
      <span class="comment-detail-<%=comment.id%>"><%= comment.contents %></span>
      <div>
          <button data-id="<%=comment.id %>" class="btn btn-warning text-white edit-comment">수정</button>
          <button data-id="<%=comment.id %>" class="btn btn-danger destroy-comment">삭제</button>
      </div>
  </li>
  <% end %>
</ul>
...
```



###  댓글 수정 입력창 & 댓글 불러와서 넣기

* 댓글이 있던 부분이 입력창으로 바뀌면서 원래 있던 댓글의 내용이 입력창에 들어간다. 수정버튼을 확인버튼으로 바꾼다.

  

*views/movies/show.html.erb*

```erb
<script>
...
    $('document').on('click','.edit-comment', function(){
        // var detail= $('.comment-detail').text();
        // console.log('detail');   이렇게 하면 댓글들이 전부합쳐서 나옴
        var comment_id = $(this).data('id');
        var edit_comment = $(`.comment-detail-${comment_id}`);
        var contents = edit_comment.text();
        edit_comment.html(`
        <input type="text" value="${contents}" class="form-control edit-comment-${comment_id}">`);
    	// 수정버튼을 확인버튼으로 바꾼다.
        $(this).text("확인").removeClass("edit-comment btn-warning").addClass("update-comment btn-dark");   
    });
...
</script>
```



------



[이벤트 리스너 + 이벤트 핸들러]

* 내용 수정 후 확인 버튼을 클릭하면 
* 입력 창에 있던 내용물이 댓글의 원래 형태로 바뀌고
* 확인버튼은 다시 수정버튼으로 바뀐다. 



### 댓글 수정 입력창의 내용 저장

*views/movies/show.html.erb*

```erb
<script>
...
    $(document).on('click', '.update-comment', function(){
        console.log("update");
        var comment_id = $(this).data('id');
        var comment_form = $(`.edit-comment-${comment_id}`); //위의 input의 class
        console.log(comment_form.val());
        var edit_comment = $(`.comment-detail-${comment_id}`);
        edit_comment.html(comment_form.val());   //수정한 내용을 집어넣어줌
        $(this).text("수정").removeClass("update-comment btn-dark").addClass("edit-comment btn-warning");
    });
    
...
</script>
```

* `$(.update-comment).on() `을  `$(document).on('click', '.update-comment'`로 바꾼다.

  Why?  Reload 필요!(처음부터 다시 읽어들이는 것)





* 입력창에 있던 내용물을 ajax로 서버에 요청을 보낸다.
* 서버에서는 해당 댓글을 찾아 내용을 업데이트한다.



*views/movies/show.html.erb* : ajax 추가

```erb
<script>
 ...
	$(document).on('click', '.update-comment', function(){
        console.log("update");
        var comment_id = $(this).data('id');
        var comment_form = $(`.edit-comment-${comment_id}`);
        $.ajax({
            url: "/movies/comments/" +comment_id,
            method: "patch",
            data: {
                contents: comment_form.val()
            }
        })
    });
...
</script>
```



*routes.rb*

```ruby
...
	collection do
      delete '/comments/:comment_id' => 'movies#destroy_comment'
      patch '/comments/:comment_id' => 'movies#update_comment'  # 추가
    end
...
```




*app/controllers/movies_controller.rb*  :  `update_comment `메서드 추가

```ruby
...
  def update_comment
    @comment = Comment.find(params[:comment_id])
    @comment.update(contents: params[:contents])
  end
...
```



*views/movies/update_comment.js.erb*  만들기

```erb
alert("수정완료");
var edit_comment = $('.comment-detail-<%= @comment.id %>');
edit_comment.html('<%= @comment.contents %>');  //수정한 내용을 집어넣어줌
$('.update-comment').text("수정").removeClass("update-comment btn-dark").addClass("edit-comment btn-warning");
```





*views/movies/create_comment.js.erb*  

: **새 댓글 작성했을때, 바로 수정가능하도록 수정버튼 추가**

```erb
$('.comment-list').prepend(`
  <li class="comment-<%= @comment.id%> list-group-item d-flex justify-content-between">
      <span class="comment-detail-<%=@comment.id%>"><%= @comment.contents %></span>
      <div>
          <button data-id="<%=@comment.id %>" class="btn btn-warning text-white edit-comment">수정</button>
          <button data-id="<%=@comment.id %>" class="btn btn-danger destroy-comment">삭제</button>
      </div>
  </li>`);
$('.comment-contents').val('');
alert("댓글이 등록되었습니다.");
```



### 댓글 수정이 한번에 하나의 댓글만 가능하게

수정버튼 하나 누르면 다른 수정버튼들은 못누르게 설정한다. 

즉, 댓글 수정은 수정 중에 한번에 하나만 되도록!



* 수정버튼을 누르면 

* 전체 문서 중에서  `update-comment` 클래스를 가진 버튼이 있는 경우에

* 더이상 진행하지 않고 이벤트 핸들러를 끝냄

  `return false` 를 하면 이벤트 핸들러가 끝난다.

  

*views/movies/show.html.erb*   : `if ($('.update-comment').length == 0)` 추가

```erb
...
<script>
...
    $(document).on('click','.edit-comment', function(){
        // var detail= $('.comment-detail').text();
        // console.log('detail');   이렇게 하면 댓글들이 전부합쳐서 나옴
        if ($('.update-comment').length == 0) {
        var comment_id = $(this).data('id');
        var edit_comment = $(`.comment-detail-${comment_id}`);
        var contents = edit_comment.text().trim();  //trim : 앞뒤공백 제거!
        edit_comment.html(`
        <input type="text" value="${contents}" class="form-control edit-comment-${comment_id}">`);
        $(this).text("확인").removeClass("edit-comment btn-warning").addClass("update-comment btn-dark");
        } else {
        alert("수정이 불가합니다.");
        }
    });
...
</script>
```





**순서**

function만들때 다만들고 ajax만드는게 편하다. 

라우트 설정하고

컨트롤러에서 메소드 정의하고

js.erb 만들기
