import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EvaluationsList } from './evaluations-list';

describe('EvaluationsList', () => {
  let component: EvaluationsList;
  let fixture: ComponentFixture<EvaluationsList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [EvaluationsList]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EvaluationsList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
