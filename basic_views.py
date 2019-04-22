from django.shortcuts import render

from django.urls import reverse
from django.views.generic import TemplateView

from django.contrib.auth.mixins import LoginRequiredMixin

# Create your views here.

class MainView(TemplateView):
    template_name = 'main.html';

    def get(self, request, *args, **kwargs):
        context = {};
        return render(request, '__MYAPPNAME__/main.html', context);

class SecureContentView(LoginRequiredMixin, TemplateView):
    template_name = 'secure.html';
    # Using 'login/' will result in a search for '/secure/login'
    login_url = '/login/';

    def get(self, request, *args, **kwargs):
        context = {};
        return render(request, '__MYAPPNAME__/secure.html', context);
