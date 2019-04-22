from django.urls import path, include

from django.contrib.auth import views as auth_views
from __MYAPPNAME__.views import MainView, SecureContentView

urlpatterns = [
    path('', MainView.as_view(), name='main'),
    path('secure/', SecureContentView.as_view(), name='secure'),
    path('login/', auth_views.LoginView.as_view(template_name='app/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='main'), name='logout'),
    path('', include('django.contrib.auth.urls')),
]
