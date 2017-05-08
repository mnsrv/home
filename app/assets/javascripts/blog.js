$(document).ready(function() {
    $.get(ghost.url.api('posts', {limit: 3})).done(function(data) {
        var posts = []
        data.posts.forEach(function(post) {
            posts.push('<h2>' + post.title + '</h2>')
        })
        $('#blog').append(posts)
    });
});
