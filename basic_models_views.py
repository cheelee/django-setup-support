from django.shortcuts import render, redirect

from django.forms import modelformset_factory
from .models import DummyForm
from .models import DummyModel

# Create your views here.

def replaceNone(data):
    for record in data:
        for idx in range(len(record)):
            if record[idx] == None:
                        record[idx] = 'None';

def main(request):
    context = {};
    queryset = DummyModel.objects.all();
    resultsList = [];
    if queryset.count() > 0:
        resultsList = [list(item) for item in queryset.values_list()];
        replaceNone(resultsList);
    context['results'] = resultsList;
    return render(request, '__MYAPPNAME__/main.html', context);

def input(request):
    context = {};
    if request.method == 'POST':
        formset = DummyForm(request.POST, request.FILES);
        # This form will report errors reported at formset.save()
        if formset.is_valid():
            formset.save();
            return redirect(main);
        context['formset'] = formset;
    else:
        formset = DummyForm();
        context['formset'] = formset;
    return render(request, '__MYAPPNAME__/input.html', context);
