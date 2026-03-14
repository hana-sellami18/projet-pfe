import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StagiairesList } from './stagiaires-list';

describe('StagiairesList', () => {
  let component: StagiairesList;
  let fixture: ComponentFixture<StagiairesList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [StagiairesList]
    })
    .compileComponents();

    fixture = TestBed.createComponent(StagiairesList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
