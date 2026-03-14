import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SujetForm } from './sujet-form';

describe('SujetForm', () => {
  let component: SujetForm;
  let fixture: ComponentFixture<SujetForm>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SujetForm]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SujetForm);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
